import 'package:rising_star_crypto_app/common/helpers.dart';
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
  Future<Map<DateTime, double>> getDailyTotalVolumesWithinRange({
    required String coin,
    required String vsCurrency,
    required DateTime from,
    required DateTime to,
  }) async {
    var jsonData = await _getMarketChartData(coin, vsCurrency, from, to);
    List<dynamic> totalVolumes = jsonData['total_volumes'];

    var allTotalVolumesWithinRange = _parseMarketChartData(totalVolumes);
    var dailyTotalVolumesWithinRange = Helpers.getDailyValuesWithinRange(
        allValuesWithinRange: allTotalVolumesWithinRange, from: from, to: to);
    return dailyTotalVolumesWithinRange;
  }

  @override
  Future<Map<DateTime, double>> getDailyMarketCapsWithinRange({
    required String coin,
    required String vsCurrency,
    required DateTime from,
    required DateTime to,
  }) async {
    var jsonData = await _getMarketChartData(coin, vsCurrency, from, to);
    List<dynamic> marketCaps = jsonData['market_caps'];
    var allMarketCapsWihtinRange = _parseMarketChartData(marketCaps);
    var dailyMarketCapsWithinRange = Helpers.getDailyValuesWithinRange(
        allValuesWithinRange: allMarketCapsWihtinRange, from: from, to: to);
    return dailyMarketCapsWithinRange;
  }

  @override
  Future<Map<DateTime, double>> getDailyPricesWithinRange({
    required String coin,
    required String vsCurrency,
    required DateTime from,
    required DateTime to,
  }) async {
    var jsonData = await _getMarketChartData(coin, vsCurrency, from, to);
    List<dynamic> pricesData = jsonData['prices'];
    var allPricesWithinRange = _parseMarketChartData(pricesData);
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

  Map<DateTime, double> _parseMarketChartData(List<dynamic> data) {
    Map<DateTime, double> dataMap = {};

    for (var item in data) {
      DateTime time = DateTime.fromMillisecondsSinceEpoch(item[0], isUtc: true);
      if (item[1] is double) {
        dataMap[time] = item[1];
      } else {
        dataMap[time] = double.tryParse(item[1].toString()) ?? -1;
      }
    }
    return dataMap;
  }
}
