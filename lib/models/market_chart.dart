import 'dart:math' as math;

class MarketChart {
  final String currency;
  final String coin;
  final DateTime startTime;
  final DateTime endTime;

  // Map<DateTime, double> pricesWithinRange = {};
  // Map<DateTime, double> marketCapsWithinRange = {};
  // Map<DateTime, double> dailyVolumeWithinRange = {};

  MarketChart({
    required this.coin,
    required this.currency,
    required this.startTime,
    required this.endTime,
  });

  Map<DateTime, double> dailyPricesWithinRange(
      Map<DateTime, double> pricesWithinRange) {
    MapEntry<DateTime, double> lastEntry =
        MapEntry(DateTime.fromMillisecondsSinceEpoch(0, isUtc: true), -1.0);

    Map<DateTime, double> dailyPrices = {};
    List<DateTime> entriesToBeRemoved = [];

    for (var entry in pricesWithinRange.entries) {
      if (_isSameDay(entry.key, lastEntry.key)) {
        entriesToBeRemoved.add(entry.key);
        continue;
      }
      lastEntry = entry;
    }
    pricesWithinRange
        .removeWhere((key, value) => entriesToBeRemoved.contains(key));

    pricesWithinRange.removeWhere((key, value) => (key.isBefore(startTime)));
    pricesWithinRange.removeWhere((key, value) {
      var firstOfLastDay = pricesWithinRange.keys
          .firstWhere((element) => _isSameDay(element, endTime));
      return key.isAfter(firstOfLastDay);
    });
    return pricesWithinRange;
  }

  Map<DateTime, double> longestDownwardTrendWithinRange(
      Map<DateTime, double> pricesWithinRange) {
    pricesWithinRange = dailyPricesWithinRange(pricesWithinRange);
    return _getPriceTrend(
        pricesWithinRange: pricesWithinRange, isDownward: false);
  }

  Map<DateTime, double> _getPriceTrend({
    required Map<DateTime, double> pricesWithinRange,
    bool isDownward = true,
  }) {
    Map<DateTime, double> longestTrend = {};

    MapEntry<DateTime, double> lastEntry =
        MapEntry(DateTime.fromMillisecondsSinceEpoch(0, isUtc: true), -1.0);

    Map<DateTime, double> trend = {};

// TODO: Make cleaner
    for (var item in pricesWithinRange.entries) {
      if (isDownward &&
          !_isSameDay(item.key, lastEntry.key) &&
          item.value < lastEntry.value) {
        if (trend.isEmpty) {
          trend[lastEntry.key] = lastEntry.value;
        }
        trend[item.key] = item.value;
      } else if (!isDownward &&
          !_isSameDay(item.key, lastEntry.key) &&
          item.value > lastEntry.value) {
        if (trend.isEmpty) {
          trend[lastEntry.key] = lastEntry.value;
        }
        trend[item.key] = item.value;
      } else {
        if (longestTrend.length < trend.length) {
          longestTrend = Map.from(trend);
        }
        trend.clear();
      }
      lastEntry = item;
    }
    return longestTrend;
  }

  bool _isSameDay(DateTime dayA, DateTime dayB) {
    if (dayA.day == dayB.day &&
        dayA.month == dayB.month &&
        dayA.year == dayB.year) {
      return true;
    }
    return false;
  }
}
