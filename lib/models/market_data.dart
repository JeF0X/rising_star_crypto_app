import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rising_star_crypto_app/common/constants.dart';
import 'package:rising_star_crypto_app/common/helpers.dart';
import 'package:rising_star_crypto_app/models/date_value_data.dart';
import 'package:rising_star_crypto_app/services/coin_gecko_data.dart';
import 'package:rising_star_crypto_app/services/coin_gecko_service.dart';
import 'package:rising_star_crypto_app/services/crypto_data.dart';

class MarketData {
  Currency currency;
  Coin coin;
  final CryptoData database = CoinGeckoData(CoinGeckoService.instance);

  late DateTimeRange dateRange;

  List<DateValueData> longestDownwardTrend = [];
  DateValueData highestDailyTradingVolume = DateValueData.empty();
  List<DateValueData> bestBuySellTimes = [];

  MarketData({
    required this.dateRange,
    required this.coin,
    required this.currency,
  });

  Future<void> updateMarketData() async {
    longestDownwardTrend = await _getLongestDownwardTrendWithinRange();
    highestDailyTradingVolume = await _getHighestDailyTradingVolume();
    bestBuySellTimes = await _getBestBuySellTimes();
  }

  Future<List<DateValueData>> _getLongestDownwardTrendWithinRange() async {
    var pricesWithinRange = await database.getDailyPricesWithinRange(
      coin: coin,
      vsCurrency: currency,
      from: dateRange.start,
      to: dateRange.end,
    );
    return await Helpers.getLongestTrend(
        valuesWithinRange: pricesWithinRange, isDownward: true);
  }

  Future<DateValueData> _getHighestDailyTradingVolume() async {
    var tradingVolumesWithinRange =
        await database.getDailyTotalVolumesWithinRange(
      coin: coin,
      vsCurrency: currency,
      from: dateRange.start,
      to: dateRange.end,
    );
    DateValueData highestEntry =
        DateValueData(DateTime.fromMillisecondsSinceEpoch(0), -1.0);
    for (var element in tradingVolumesWithinRange) {
      if (element.value > highestEntry.value) {
        highestEntry = element;
      }
    }

    return highestEntry;
  }

  Future<List<DateValueData>> _getBestBuySellTimes() async {
    var dailyPrices = await database.getDailyPricesWithinRange(
      coin: coin,
      vsCurrency: currency,
      from: dateRange.start,
      to: dateRange.end,
    );
    List<DateValueData> pricesLowToHigh = List.from(dailyPrices);
    var bestBuySellTimes =
        await compute(_computeBestBuySellTimes, pricesLowToHigh);
    return bestBuySellTimes;
  }
}

List<DateValueData> _computeBestBuySellTimes(
    List<DateValueData> pricesLowToHigh) {
  pricesLowToHigh.sort((a, b) {
    if (a.value > b.value) {
      return 1;
    } else {
      return -1;
    }
  });
  DateValueData bestBuyEntry = DateValueData(DateTime.now(), -1.0);
  DateValueData bestSellEntry = DateValueData(DateTime.now(), 1.0);

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
  log('Iterations: $iterations');
  if (bestBuyEntry.value > 0.0) {
    log('Best time to buy is ${bestBuyEntry.date.toString()} and sell ${bestSellEntry.date.toString()}');
    log('Low price: ${bestBuyEntry.value.toString()}, high price: ${bestSellEntry.value.toString()}');
    List<DateValueData> dates = [bestBuyEntry, bestSellEntry];

    return dates;
  } else {
    log('Not found');
  }
  return <DateValueData>[];
}
