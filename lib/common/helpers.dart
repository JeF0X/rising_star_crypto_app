class Helpers {
  static bool isSameDay(DateTime dayA, DateTime dayB) {
    if (dayA.day == dayB.day &&
        dayA.month == dayB.month &&
        dayA.year == dayB.year) {
      return true;
    }
    return false;
  }

  static Map<DateTime, double> getDailyValuesWithinRange({
    required Map<DateTime, double> allValuesWithinRange,
    required DateTime from,
    required DateTime to,
  }) {
    Map<DateTime, double> dailyValuesWithinRange =
        Map.from(allValuesWithinRange);

    List<DateTime> entriesToBeRemoved = [];
    MapEntry<DateTime, double> lastEntry =
        MapEntry(DateTime.fromMillisecondsSinceEpoch(0, isUtc: true), -1.0);
    for (var entry in dailyValuesWithinRange.entries) {
      if (Helpers.isSameDay(entry.key, lastEntry.key)) {
        entriesToBeRemoved.add(entry.key);
        continue;
      }
      lastEntry = entry;
    }
    dailyValuesWithinRange
        .removeWhere((key, value) => entriesToBeRemoved.contains(key));

    dailyValuesWithinRange.removeWhere((key, value) => (key.isBefore(from)));
    dailyValuesWithinRange.removeWhere((key, value) {
      var firstOfLastDay = dailyValuesWithinRange.keys
          .firstWhere((element) => Helpers.isSameDay(element, to));
      return key.isAfter(firstOfLastDay);
    });
    return dailyValuesWithinRange;
  }

  static Map<DateTime, double> getLongestTrend({
    required Map<DateTime, double> valuesWithinRange,
    bool isDownward = true,
  }) {
    Map<DateTime, double> longestTrend = {};

    MapEntry<DateTime, double> lastEntry =
        MapEntry(DateTime.fromMillisecondsSinceEpoch(0, isUtc: true), -1.0);

    Map<DateTime, double> trend = {};

// TODO: Make cleaner
    for (var item in valuesWithinRange.entries) {
      if (isDownward &&
          !Helpers.isSameDay(item.key, lastEntry.key) &&
          item.value < lastEntry.value) {
        if (trend.isEmpty) {
          trend[lastEntry.key] = lastEntry.value;
        }
        trend[item.key] = item.value;
      } else if (!isDownward &&
          !Helpers.isSameDay(item.key, lastEntry.key) &&
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
}
