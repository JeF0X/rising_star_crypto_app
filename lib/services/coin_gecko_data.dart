import 'package:flutter/foundation.dart';
import 'package:rising_star_crypto_app/common/constants.dart';
import 'package:rising_star_crypto_app/common/helpers.dart';
import 'package:rising_star_crypto_app/models/date_value_data.dart';
import 'package:rising_star_crypto_app/services/coin_gecko_service.dart';
import 'package:rising_star_crypto_app/services/crypto_data.dart';

class CoinGeckoData implements CryptoData {
  Map<String, dynamic>? _lastMarketChartData;
  String? lastCoin;
  String? lastCurrency;
  DateTime? lastStartTime;
  DateTime? lastEndTime;
  final CoinGeckoService service;

  CoinGeckoData(this.service);

  @override
  Future<List<DateValueData>> getDailyTotalVolumesWithinRange({
    required Coin coin,
    required Currency vsCurrency,
    required DateTime from,
    required DateTime to,
  }) async {
    var coinString = Helpers.getCoinGeckoCoinString(coin);
    var currencyString = Helpers.getCoinGeckoCurrencyString(vsCurrency);
    var jsonData =
        await _getMarketChartData(coinString, currencyString, from, to);
    List<dynamic> totalVolumes = jsonData['total_volumes'];

    var allTotalVolumesWithinRange =
        await compute(_parseMarketChartData, totalVolumes);
    var dailyTotalVolumesWithinRange = _getDailyValuesWithinRange(
        allValuesWithinRange: allTotalVolumesWithinRange, from: from, to: to);

    return dailyTotalVolumesWithinRange;
  }

  @override
  Future<List<DateValueData>> getDailyMarketCapsWithinRange({
    required Coin coin,
    required Currency vsCurrency,
    required DateTime from,
    required DateTime to,
  }) async {
    var coinString = Helpers.getCoinGeckoCoinString(coin);
    var currencyString = Helpers.getCoinGeckoCurrencyString(vsCurrency);
    var jsonData =
        await _getMarketChartData(coinString, currencyString, from, to);
    List<dynamic> marketCaps = jsonData['market_caps'];
    var allMarketCapsWihtinRange =
        await compute(_parseMarketChartData, marketCaps);
    var dailyMarketCapsWithinRange = _getDailyValuesWithinRange(
        allValuesWithinRange: allMarketCapsWihtinRange, from: from, to: to);
    return dailyMarketCapsWithinRange;
  }

  @override
  Future<List<DateValueData>> getDailyPricesWithinRange({
    required Coin coin,
    required Currency vsCurrency,
    required DateTime from,
    required DateTime to,
  }) async {
    var coinString = Helpers.getCoinGeckoCoinString(coin);
    var currencyString = Helpers.getCoinGeckoCurrencyString(vsCurrency);

    var jsonData =
        await _getMarketChartData(coinString, currencyString, from, to);
    List<dynamic> pricesData = jsonData['prices'];
    var allPricesWithinRange = await compute(_parseMarketChartData, pricesData);
    var dailyPricesWithinRange = _getDailyValuesWithinRange(
        allValuesWithinRange: allPricesWithinRange, from: from, to: to);
    return dailyPricesWithinRange;
  }

  Future<Map<String, dynamic>> _getMarketChartData(
      String coin, String currency, DateTime from, DateTime to) async {
    if (lastCoin == coin &&
        lastCurrency == currency &&
        lastStartTime == from &&
        lastEndTime == to &&
        _lastMarketChartData != null) {
      // Return cached market data if query is same as last one
      return Future.value(_lastMarketChartData);
    }

    var jsonData = await service.getMarketChartRange(
      coin: coin,
      vsCurrency: currency,
      unixTimeFrom: from.millisecondsSinceEpoch ~/ 1000 - 86400,
      unixTimeTo: to.millisecondsSinceEpoch ~/ 1000 + 86400,
    );
    _lastMarketChartData = jsonData;
    lastCoin = coin;
    lastCurrency = currency;
    lastStartTime = from;
    lastEndTime = to;
    return jsonData;
  }

  List<DateValueData> _parseMarketChartData(List<dynamic> data) {
    Map<DateTime, double> dataMap = {};
    List<DateValueData> dateValues = [];

    for (var item in data) {
      DateTime time = DateTime.fromMillisecondsSinceEpoch(item[0], isUtc: true);

      if (item[1] is double) {
        dataMap[time] = item[1];
        dateValues.add(DateValueData(time, item[1]));
      } else {
        dataMap[time] = double.tryParse(item[1].toString()) ?? -1;
        var value = double.tryParse(item[1].toString()) ?? -1;

        dateValues.add(DateValueData(time, value));
      }
    }
    return dateValues;
  }

  /// Get first value for every day between [from] and [to] in [allValuesWithinRange]
  Future<List<DateValueData>> _getDailyValuesWithinRange({
    required List<DateValueData> allValuesWithinRange,
    required DateTime from,
    required DateTime to,
  }) async {
    List<DateValueData> dailyValuesWithinRange =
        List.from(allValuesWithinRange);

    List<DateValueData> dailyEntries =
        await compute(_computeDailyEntries, dailyValuesWithinRange);
    for (int index = 0; index < dailyEntries.length; index++) {
      if (dailyEntries[index].date.isBefore(from)) {
        dailyEntries.removeAt(index);
      } else {
        break;
      }
    }

    for (int index = dailyEntries.length - 1; index >= 0; index--) {
      if (dailyEntries[index - 1].date.isAfter(to) && index > 0) {
        dailyEntries.removeAt(index);
      } else {
        break;
      }
    }

    // dailyEntries.removeWhere((item) => (item.date.isBefore(from)));
    // dailyEntries.removeWhere((item) {
    //   DateValueData firstDataPointOfLastDay = dailyEntries.firstWhere(
    //       (element) => Helpers.isSameDay(element.date, to),
    //       orElse: () => dailyEntries.last);
    //   return item.date.isAfter(firstDataPointOfLastDay.date);
    // });

    return dailyEntries;
  }

  List<DateValueData> _computeDailyEntries(
      List<DateValueData> dailyValuesWithinRange) {
    List<DateValueData> dailyEntries = [];
    DateValueData lastItem = DateValueData(
        DateTime.fromMillisecondsSinceEpoch(0, isUtc: true), -1.0);
    for (var item in dailyValuesWithinRange) {
      if (Helpers.isSameDay(item.date, lastItem.date)) {
        continue;
      }
      dailyEntries.add(item);
      lastItem = item;
    }
    return dailyEntries;
  }
}
