import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rising_star_crypto_app/common/constants.dart';
import 'package:rising_star_crypto_app/services/coin_gecko_data.dart';
import 'package:rising_star_crypto_app/services/coin_gecko_service.dart';

import 'coin_gecko_data_test.mocks.dart';
import 'coin_gecko_test_data.dart';

@GenerateMocks([CoinGeckoService])
void main() {
  test('getDailyPricesWithinRange', () async {
    final service = MockCoinGeckoService();
    final coinGeckoData = CoinGeckoData(service);

    when(service.getMarketChartRange(
      coin: anyNamed('coin'),
      vsCurrency: anyNamed('vsCurrency'),
      unixTimeFrom: anyNamed('unixTimeFrom'),
      unixTimeTo: anyNamed('unixTimeTo'),
    )).thenAnswer((_) => Future.value(coinGeckoTestDataHourly));

    var dailyPrices = await coinGeckoData.getDailyPricesWithinRange(
      coin: Coin.bitcoin,
      vsCurrency: Currency.euro,
      from: DateTime.fromMillisecondsSinceEpoch(1609460362756, isUtc: true),
      to: DateTime.fromMillisecondsSinceEpoch(1609553227754, isUtc: true),
    );

    expect(dailyPrices.first.value, 2.0);
    expect(dailyPrices.last.value, 3.0);
  });
}
