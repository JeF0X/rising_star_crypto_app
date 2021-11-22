import 'package:rising_star_crypto_app/models/market_chart.dart';

abstract class CryptoData {
  Future<Map<DateTime, double>> getPricesWithinRange(MarketChart marketChart);
  Future<Map<DateTime, double>> getMarketCapsWithinRange(
      MarketChart marketChart);
  Future<Map<DateTime, double>> getDailyhVolumeWithinRange(
      MarketChart marketChart);
}
