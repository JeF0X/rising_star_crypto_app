import 'package:rising_star_crypto_app/common/helpers.dart';

class MarketChartData {
  final String currency;
  final String coin;
  Map<DateTime, double>? dailyPrices;
  Map<DateTime, double>? dailyTotalVolume;
  Map<DateTime, double>? dailyMarketCaps;

  MarketChartData({
    required this.coin,
    required this.currency,
    this.dailyPrices,
    this.dailyTotalVolume,
    this.dailyMarketCaps,
  });

  static Map<DateTime, double> getLongestDownwardTrendWithinRange(
      Map<DateTime, double> pricesWithinRange) {
    return Helpers.getLongestTrend(
        valuesWithinRange: pricesWithinRange, isDownward: true);
  }

  static MapEntry<DateTime, double> getHighestDailyTradingVolume(
      Map<DateTime, double> tradingVolumesWithinRange) {
    MapEntry<DateTime, double> highestEntry =
        MapEntry(DateTime.fromMillisecondsSinceEpoch(0), -1.0);
    for (var element in tradingVolumesWithinRange.entries) {
      if (element.value > highestEntry.value) {
        highestEntry = element;
      }
    }

    return highestEntry;
  }
}
