import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:rising_star_crypto_app/common/constants.dart';
import 'package:rising_star_crypto_app/common/helpers.dart';
import 'package:rising_star_crypto_app/models/date_value.dart';
import 'package:rising_star_crypto_app/services/coin_gecko_data.dart';
import 'package:rising_star_crypto_app/services/crypto_data.dart';

class MarketData {
  Currency currency;
  Coin coin;
  final CryptoData database = CoinGeckoData.instance;

  late DateTimeRange _dateRange;
  List<DateValueData>? _dailyPrices;
  List<DateValueData>? _dailyTotalVolume;
  List<DateValueData>? _dailyMarketCaps;

  List<DateValueData> longestDownwardTrend = [];
  DateValueData highestDailyTradingVolume = DateValueData.empty();
  List<DateValueData> bestBuySellTimes = [];

  MarketData({
    required DateTimeRange dateTimeRange,
    required this.coin,
    required this.currency,
  }) {
    _dateRange = dateTimeRange;
  }

  set dateRange(DateTimeRange dateRange) {
    if (_dateRange.start != dateRange.start &&
        _dateRange.end != dateRange.end) {
      _dailyPrices = null;
      _dailyTotalVolume = null;
      _dailyMarketCaps = null;
    }
    _dateRange = dateRange;
  }

  DateTimeRange get dateRange => _dateRange;

  Future<MarketData> updateMarketData() async {
    longestDownwardTrend = await getLongestDownwardTrendWithinRange();
    highestDailyTradingVolume = await getHighestDailyTradingVolume();
    bestBuySellTimes = await getBestBuySellTimes();

    return this;
  }

  Future<List<DateValueData>> _getDailyPrices() async {
    if (_dailyPrices != null) {
      return Future.value(_dailyPrices);
    }
    return await database.getDailyPricesWithinRange(
      coin: coin,
      vsCurrency: currency,
      from: _dateRange.start,
      to: _dateRange.end,
    );
  }

  Future<List<DateValueData>> _getDailyTotalVolume() async {
    if (_dailyTotalVolume != null) {
      return Future.value(_dailyTotalVolume);
    }
    return await database.getDailyTotalVolumesWithinRange(
      coin: coin,
      vsCurrency: currency,
      from: _dateRange.start,
      to: _dateRange.end,
    );
  }

  // ignore: unused_element
  Future<List<DateValueData>> _getDailyMarketCaps() async {
    if (_dailyMarketCaps != null) {
      return Future.value(_dailyMarketCaps);
    }
    return await database.getDailyMarketCapsWithinRange(
      coin: coin,
      vsCurrency: currency,
      from: _dateRange.start,
      to: _dateRange.end,
    );
  }

  Future<List<DateValueData>> getLongestDownwardTrendWithinRange() async {
    var pricesWithinRange = await _getDailyPrices();
    return Helpers.getLongestTrend(
        valuesWithinRange: pricesWithinRange, isDownward: true);
  }

  Future<DateValueData> getHighestDailyTradingVolume() async {
    var tradingVolumesWithinRange = await _getDailyTotalVolume();
    DateValueData highestEntry =
        DateValueData(DateTime.fromMillisecondsSinceEpoch(0), -1.0);
    for (var element in tradingVolumesWithinRange) {
      if (element.value > highestEntry.value) {
        highestEntry = element;
      }
    }

    return highestEntry;
  }

  Future<List<DateValueData>> getBestBuySellTimes() async {
    // TODO: Calculate in a new thread
    List<DateValueData> pricesLowToHigh = List.from(await _getDailyPrices());

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

    if (bestBuyEntry.value > 0.0) {
      log('Best time to buy is ${bestBuyEntry.date.toString()} and sell ${bestSellEntry.date.toString()}');
      log('Low price: ${bestBuyEntry.value.toString()}, high price: ${bestSellEntry.value.toString()}');
      List<DateValueData> dates = [bestBuyEntry, bestSellEntry];
      return dates;
    } else {
      log('Not found');
    }
    log('Iterations: $iterations');
    return <DateValueData>[];
  }
}
