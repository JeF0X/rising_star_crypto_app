import 'dart:convert';
import 'dart:developer';

import 'package:rising_star_crypto_app/models/market_chart.dart';
import 'package:rising_star_crypto_app/services/crypto_data.dart';
import 'package:http/http.dart' as http;

// API Documentation: https://www.coingecko.com/en/api/documentation

class CoinGeckoService implements CryptoData {
  static const _apiUrl = 'https://api.coingecko.com/api/v3/';
  static const int statusOk = 200;

  CoinGeckoService._();
  static final instance = CoinGeckoService._();

  Map<String, dynamic>? _lastMarketChartData;
  String? lastCoin;
  String? lastCurrency;
  DateTime? lastStartTime;
  DateTime? lastEndTime;

  @override
  Future<Map<DateTime, double>> getDailyhVolumeWithinRange(
      MarketChart marketChart) async {
    var jsonData = await _getMarketChart(marketChart);
    List<dynamic> totalVolumes = jsonData['total_volumes'];

    return _parseData(totalVolumes);
  }

  @override
  Future<Map<DateTime, double>> getMarketCapsWithinRange(
      MarketChart marketChart) async {
    var jsonData = await _getMarketChart(marketChart);
    List<dynamic> marketCaps = jsonData['market_caps'];

    return _parseData(marketCaps);
  }

  @override
  Future<Map<DateTime, double>> getPricesWithinRange(
      MarketChart marketChart) async {
    var jsonData = await _getMarketChart(marketChart);
    List<dynamic> prices = jsonData['prices'];

    return _parseData(prices);
  }

  Map<DateTime, double> _parseData(List<dynamic> prices) {
    Map<DateTime, double> pricesMap = {};
    for (var item in prices) {
      DateTime time = DateTime.fromMillisecondsSinceEpoch(item[0], isUtc: true);
      pricesMap[time] = item[1];
    }
    return pricesMap;
  }

  Future<Map<String, dynamic>> _getMarketChart(MarketChart marketChart) async {
    if (lastCoin == marketChart.coin &&
        lastCurrency == marketChart.currency &&
        lastStartTime == marketChart.startTime &&
        lastEndTime == marketChart.endTime &&
        _lastMarketChartData != null) {
      return Future.value(_lastMarketChartData);
    }

    String url = _apiUrl +
        'coins/${marketChart.coin}/market_chart/range?vs_currency=${marketChart.currency}&from=${marketChart.startTime.toUtc().millisecondsSinceEpoch / 1000}&to=${marketChart.endTime.toUtc().millisecondsSinceEpoch / 1000}';
    log(url);
    Map<String, dynamic>? marketChartData = await _sendRequest(url);
    if (marketChartData != null) {
      lastCoin = marketChart.coin;
      lastCurrency = marketChart.currency;
      lastStartTime = marketChart.startTime;
      lastEndTime = marketChart.endTime;
      _lastMarketChartData = marketChartData;
      return marketChartData;
    } else {
      throw Exception('Data was null');
    }
  }

  Future<Map<String, dynamic>?> _sendRequest(String url) async {
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == statusOk) {
      Map<String, dynamic>? jsonBody = json.decode(response.body);

      return jsonBody;
    } else {
      // TODO: Handle exceptions
      throw Exception('Could not load data');
    }
  }
}
