import 'package:rising_star_crypto_app/common/constants.dart';
import 'package:rising_star_crypto_app/models/date_value.dart';

abstract class CryptoData {
  Future<List<DateValueData>> getDailyPricesWithinRange({
    required Coin coin,
    required Currency vsCurrency,
    required DateTime from,
    required DateTime to,
  });
  Future<List<DateValueData>> getDailyMarketCapsWithinRange({
    required Coin coin,
    required Currency vsCurrency,
    required DateTime from,
    required DateTime to,
  });
  Future<List<DateValueData>> getDailyTotalVolumesWithinRange({
    required Coin coin,
    required Currency vsCurrency,
    required DateTime from,
    required DateTime to,
  });
}
