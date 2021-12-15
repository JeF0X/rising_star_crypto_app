import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rising_star_crypto_app/common/constants.dart';
import 'package:rising_star_crypto_app/services/coin_gecko_service.dart';
import 'package:rising_star_crypto_app/services/http_service.dart';

import 'coin_gecko_service_test.mocks.dart';
import 'coin_gecko_test_data.dart';

@GenerateMocks([HttpService])
void main() {
  int startTime = DateTime.utc(2021, 1, 1).millisecondsSinceEpoch ~/ 1000;
  int endTime = DateTime.utc(2021, 1, 10).millisecondsSinceEpoch ~/ 1000;
  test('getMarketChartRange, valid data', () async {
    final mockHttpService = MockHttpService();

    final service = CoinGeckoService.instance;
    when(mockHttpService.sendRequest(any))
        .thenAnswer((_) => Future.value(coinGeckoTestDataLong));

    var data = await service.getMarketChartRange(
        coin: coinGeckoCoins(Coin.bitcoin),
        vsCurrency: coinGeckoCurrencies(Currency.euro),
        unixTimeFrom: startTime,
        unixTimeTo: endTime);

    expect(data.keys.first, 'prices');
    expect(data.keys.last, 'total_volumes');
  });
}
