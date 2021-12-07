import 'dart:developer';

import 'package:rising_star_crypto_app/common/helpers.dart';
import 'package:rising_star_crypto_app/models/date_value.dart';

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

  static List<DateValue> getLongestDownwardTrendWithinRange(
      List<DateValue> pricesWithinRange) {
    return Helpers.getLongestTrend(
        valuesWithinRange: pricesWithinRange, isDownward: true);
  }

  static DateValue getHighestDailyTradingVolume(
      List<DateValue> tradingVolumesWithinRange) {
    DateValue highestEntry =
        DateValue(DateTime.fromMillisecondsSinceEpoch(0), -1.0);
    for (var element in tradingVolumesWithinRange) {
      if (element.value > highestEntry.value) {
        highestEntry = element;
      }
    }

    return highestEntry;
  }

  static void calculateBestBuySellTimes(List<DateValue> pricesWithinRange) {
    // TODO: Calculate in a new thread
    List<DateValue> pricesLowToHigh = List.from(pricesWithinRange);

    pricesLowToHigh.sort((a, b) {
      if (a.value > b.value) {
        return 1;
      } else {
        return -1;
      }
    });
    DateValue bestBuyEntry = DateValue(DateTime.now(), -1.0);
    DateValue bestSellEntry = DateValue(DateTime.now(), 1.0);

    int iterations = 0;
    for (int index = pricesLowToHigh.length - 1; index >= 0; index--) {
      for (var item in pricesLowToHigh) {
        iterations++;
        if (item.date == pricesLowToHigh[index].date) {
          break;
        }
        if (item.date.isBefore(pricesLowToHigh[index].date) &&
            item.value < pricesLowToHigh[index].value) {
          if (bestSellEntry.value / bestBuyEntry.value <
              pricesLowToHigh[index].value / item.value) {
            bestBuyEntry = item;
            bestSellEntry = pricesLowToHigh[index];
          }
        }
      }
    }

    if (bestBuyEntry.value > 0.0) {
      log('Best time to buy is ${bestBuyEntry.date.toString()} and sell ${bestSellEntry.date.toString()}');
      log('Low price: ${bestBuyEntry.value.toString()}, high price: ${bestSellEntry.value.toString()}');
    } else {
      log('Not found');
    }
    log('Iterations: $iterations');
  }
}
