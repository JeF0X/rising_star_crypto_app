import 'package:rising_star_crypto_app/models/date_value_data.dart';

class Helpers {
  static bool isSameDay(DateTime dayA, DateTime dayB) {
    var dayAUTC = dayA.toUtc();
    var dayBUTC = dayB.toUtc();
    if (dayAUTC.day == dayBUTC.day &&
        dayAUTC.month == dayBUTC.month &&
        dayAUTC.year == dayBUTC.year) {
      return true;
    }
    return false;
  }

  static List<DateValueData> getDailyValuesWithinRange({
    required List<DateValueData> allValuesWithinRange,
    required DateTime from,
    required DateTime to,
  }) {
    List<DateValueData> dailyValuesWithinRange =
        List.from(allValuesWithinRange);

    List<DateValueData> entriesToBeRemoved = [];
    DateValueData lastItem = DateValueData(
        DateTime.fromMillisecondsSinceEpoch(0, isUtc: true), -1.0);
    for (var item in dailyValuesWithinRange) {
      if (Helpers.isSameDay(item.date, lastItem.date)) {
        entriesToBeRemoved.add(item);
        continue;
      }
      lastItem = item;
    }
    dailyValuesWithinRange
        .removeWhere((item) => entriesToBeRemoved.contains(item));

    dailyValuesWithinRange.removeWhere((item) => (item.date.isBefore(from)));
    dailyValuesWithinRange.removeWhere((item) {
      DateValueData firstDataPointOfLastDay = dailyValuesWithinRange.firstWhere(
          (element) => Helpers.isSameDay(element.date, to),
          orElse: () => dailyValuesWithinRange.last);
      return item.date.isAfter(firstDataPointOfLastDay.date);
    });

    return dailyValuesWithinRange;
  }

  static Future<List<DateValueData>> getLongestTrend({
    required List<DateValueData> valuesWithinRange,
    bool isDownward = true,
  }) async {
    List<DateValueData> longestTrend = [];

    DateValueData lastEntry = DateValueData(
        DateTime.fromMillisecondsSinceEpoch(0, isUtc: true), -1.0);

    List<DateValueData> trend = [];

    for (var datapoint in valuesWithinRange) {
      if (isDownward &&
          !Helpers.isSameDay(datapoint.date, lastEntry.date) &&
          datapoint.value < lastEntry.value) {
        if (trend.isEmpty) {
          trend.add(lastEntry);
        }
        trend.add(datapoint);
      } else if (!isDownward &&
          !Helpers.isSameDay(datapoint.date, lastEntry.date) &&
          datapoint.value > lastEntry.value) {
        if (trend.isEmpty) {
          trend.add(lastEntry);
        }
        trend.add(datapoint);
      } else {
        if (longestTrend.length < trend.length) {
          longestTrend = List.from(trend);
        }
        trend.clear();
      }
      lastEntry = datapoint;
    }
    if (trend.length > longestTrend.length) {
      longestTrend = trend;
    }
    return longestTrend;
  }
}
