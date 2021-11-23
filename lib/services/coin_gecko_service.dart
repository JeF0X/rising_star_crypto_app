import 'package:rising_star_crypto_app/services/http_service.dart';

// API Documentation: https://www.coingecko.com/en/api/documentation

class CoinGeckoService {
  static const _apiUrl = 'https://api.coingecko.com/api/v3/';

  CoinGeckoService._();
  static final instance = CoinGeckoService._();

  final HttpService httpService = HttpService();

// CODES
  // market_chart/range
  Future<Map<String, dynamic>> getMarketChartRange({
    required String coin,
    required String vsCurrency,
    required int unixTimeFrom,
    required int unixTimeTo,
  }) async {
    var url = _apiUrl +
        'coins/$coin/market_chart/range?vs_currency=$vsCurrency&from=$unixTimeFrom&to=$unixTimeTo';
    var marketChartData = await httpService.sendRequest(url);
    if (marketChartData != null) {
      return marketChartData;
    } else {
      throw Exception('Data was null');
    }
  }
}
