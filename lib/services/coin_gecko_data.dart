import 'package:flutter/foundation.dart';
import 'package:rising_star_crypto_app/common/constants.dart';
import 'package:rising_star_crypto_app/common/helpers.dart';
import 'package:rising_star_crypto_app/models/date_value.dart';
import 'package:rising_star_crypto_app/services/coin_gecko_service.dart';
import 'package:rising_star_crypto_app/services/crypto_data.dart';

class CoinGeckoData implements CryptoData {
  Map<String, dynamic>? _lastMarketChartData;
  String? lastCoin;
  String? lastCurrency;
  DateTime? lastStartTime;
  DateTime? lastEndTime;

  CoinGeckoData._();
  static final instance = CoinGeckoData._();

  final CoinGeckoService service = CoinGeckoService.instance;

  @override
  Future<List<DateValueData>> getDailyTotalVolumesWithinRange({
    required Coin coin,
    required Currency vsCurrency,
    required DateTime from,
    required DateTime to,
  }) async {
    var coinString = coinGeckoCoins(coin);
    var currencyString = coinGeckoCurrencies(vsCurrency);
    var jsonData =
        await _getMarketChartData(coinString, currencyString, from, to);
    List<dynamic> totalVolumes = jsonData['total_volumes'];

    var allTotalVolumesWithinRange =
        await compute(_parseMarketChartData, totalVolumes);
    var dailyTotalVolumesWithinRange = Helpers.getDailyValuesWithinRange(
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
    var coinString = coinGeckoCoins(coin);
    var currencyString = coinGeckoCurrencies(vsCurrency);
    var jsonData =
        await _getMarketChartData(coinString, currencyString, from, to);
    List<dynamic> marketCaps = jsonData['market_caps'];
    var allMarketCapsWihtinRange =
        await compute(_parseMarketChartData, marketCaps);
    var dailyMarketCapsWithinRange = Helpers.getDailyValuesWithinRange(
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
    var coinString = coinGeckoCoins(coin);
    var currencyString = coinGeckoCurrencies(vsCurrency);
    var jsonData =
        await _getMarketChartData(coinString, currencyString, from, to);
    List<dynamic> pricesData = jsonData['prices'];
    var allPricesWithinRange = await compute(_parseMarketChartData, pricesData);
    var dailyPricesWithinRange = Helpers.getDailyValuesWithinRange(
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
      // TODO: Handle errors
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
}
