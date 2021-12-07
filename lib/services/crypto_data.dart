import 'package:rising_star_crypto_app/models/date_value.dart';

abstract class CryptoData {
  Future<List<DateValue>> getDailyPricesWithinRange({
    required String coin,
    required String vsCurrency,
    required DateTime from,
    required DateTime to,
  });
  Future<List<DateValue>> getDailyMarketCapsWithinRange({
    required String coin,
    required String vsCurrency,
    required DateTime from,
    required DateTime to,
  });
  Future<List<DateValue>> getDailyTotalVolumesWithinRange({
    required String coin,
    required String vsCurrency,
    required DateTime from,
    required DateTime to,
  });
}
