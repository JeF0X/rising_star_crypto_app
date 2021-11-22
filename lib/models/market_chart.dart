import 'package:rising_star_crypto_app/services/coin_gecko_service.dart';
import 'package:rising_star_crypto_app/services/crypto_data.dart';

class MarketChart {
  final String currency;
  final String coin;
  final DateTime startTime;
  final DateTime endTime;

  CryptoData data = CoinGeckoService.instance;
  Map<DateTime, double> pricesWithinRange = {};
  Map<DateTime, double> marketCapsWithinRange = {};
  Map<DateTime, double> dailyVolumeWithinRange = {};

  MarketChart({
    required this.coin,
    required this.currency,
    required this.startTime,
    required this.endTime,
  });

  Future<MarketChart> getMarketChart() async {
    pricesWithinRange = await data.getMarketCapsWithinRange(this);
    marketCapsWithinRange = await data.getMarketCapsWithinRange(this);
    dailyVolumeWithinRange = await data.getDailyhVolumeWithinRange(this);
    return this;
  }
}
