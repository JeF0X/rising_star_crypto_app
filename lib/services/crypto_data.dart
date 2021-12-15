import 'package:rising_star_crypto_app/common/constants.dart';
import 'package:rising_star_crypto_app/models/date_value_data.dart';

abstract class CryptoData {
  /// Daily prices ass close to 00:00 UTC as possible.
  Future<List<DateValueData>> getDailyPricesWithinRange({
    required Coin coin,
    required Currency vsCurrency,
    required DateTime from,
    required DateTime to,
  });

  /// Daily market caps ass close to 00:00 UTC as possible.
  Future<List<DateValueData>> getDailyMarketCapsWithinRange({
    required Coin coin,
    required Currency vsCurrency,
    required DateTime from,
    required DateTime to,
  });

  /// Daily total volume ass close to 00:00 UTC as possible.
  Future<List<DateValueData>> getDailyTotalVolumesWithinRange({
    required Coin coin,
    required Currency vsCurrency,
    required DateTime from,
    required DateTime to,
  });
}
