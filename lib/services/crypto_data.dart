import 'package:rising_star_crypto_app/models/date_value.dart';

abstract class CryptoData {
  Future<List<DateValueData>> getDailyPricesWithinRange({
    required String coin,
    required String vsCurrency,
    required DateTime from,
    required DateTime to,
  });
  Future<List<DateValueData>> getDailyMarketCapsWithinRange({
    required String coin,
    required String vsCurrency,
    required DateTime from,
    required DateTime to,
  });
  Future<List<DateValueData>> getDailyTotalVolumesWithinRange({
    required String coin,
    required String vsCurrency,
    required DateTime from,
    required DateTime to,
  });
}
