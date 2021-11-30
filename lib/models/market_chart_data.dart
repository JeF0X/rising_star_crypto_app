import 'dart:developer';

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

  static void calculateBestBuySellTimes(
      Map<DateTime, double> pricesWithinRange) {
    // TODO: Calculate in a new thread
    List<MapEntry<DateTime, double>> pricesLowToHigh =
        pricesWithinRange.entries.toList();

    pricesLowToHigh.sort((a, b) {
      if (a.value > b.value) {
        return 1;
      } else {
        return -1;
      }
    });
    MapEntry<DateTime, double> bestBuyEntry = MapEntry(DateTime.now(), -1.0);
    MapEntry<DateTime, double> bestSellEntry = MapEntry(DateTime.now(), 1.0);

    int iterations = 0;
    for (int index = pricesLowToHigh.length - 1; index >= 0; index--) {
      for (var item in pricesLowToHigh) {
        iterations++;
        if (item.key == pricesLowToHigh[index].key) {
          break;
        }
        if (item.key.isBefore(pricesLowToHigh[index].key) &&
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
      log('Best time to buy is ${bestBuyEntry.key.toString()} and sell ${bestSellEntry.key.toString()}');
      log('Low price: ${bestBuyEntry.value.toString()}, high price: ${bestSellEntry.value.toString()}');
    } else {
      log('Not found');
    }
    log('Iterations: $iterations');
  }
}
