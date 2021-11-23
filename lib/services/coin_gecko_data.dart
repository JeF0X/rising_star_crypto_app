import 'package:rising_star_crypto_app/models/market_chart.dart';
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
  Future<Map<DateTime, double>> getDailyhVolumeWithinRange(
      MarketChart marketChart) async {
    var jsonData = await _getMarketChartData(marketChart);
    List<dynamic> totalVolumes = jsonData['total_volumes'];
    return _parseMarketChartData(totalVolumes);
  }

  @override
  Future<Map<DateTime, double>> getMarketCapsWithinRange(
      MarketChart marketChart) async {
    var jsonData = await _getMarketChartData(marketChart);
    List<dynamic> marketCaps = jsonData['market_caps'];
    return _parseMarketChartData(marketCaps);
  }

  @override
  Future<Map<DateTime, double>> getPricesWithinRange(
      MarketChart marketChart) async {
    var jsonData = await _getMarketChartData(marketChart);
    List<dynamic> prices = jsonData['prices'];
    return _parseMarketChartData(prices);
  }

  Future<Map<String, dynamic>> _getMarketChartData(
      MarketChart marketChart) async {
    if (lastCoin == marketChart.coin &&
        lastCurrency == marketChart.currency &&
        lastStartTime == marketChart.startTime &&
        lastEndTime == marketChart.endTime &&
        _lastMarketChartData != null) {
      // TODO: Handle errors
      return Future.value(_lastMarketChartData);
    }

    var jsonData = await service.getMarketChartRange(
      coin: marketChart.coin,
      vsCurrency: marketChart.currency,
      unixTimeFrom:
          marketChart.startTime.millisecondsSinceEpoch ~/ 1000 - 86400,
      unixTimeTo: marketChart.endTime.millisecondsSinceEpoch ~/ 1000 + 86400,
    );
    _lastMarketChartData = jsonData;
    lastCoin = marketChart.coin;
    lastCurrency = marketChart.currency;
    lastStartTime = marketChart.startTime;
    lastEndTime = marketChart.endTime;
    return jsonData;
  }

  Map<DateTime, double> _parseMarketChartData(List<dynamic> data) {
    Map<DateTime, double> dataMap = {};
    for (var item in data) {
      DateTime time = DateTime.fromMillisecondsSinceEpoch(item[0], isUtc: true);
      dataMap[time] = item[1];
    }
    return dataMap;
  }
}
