import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rising_star_crypto_app/common/constants.dart';
import 'package:rising_star_crypto_app/models/market_data.dart';
import 'package:rising_star_crypto_app/services/coin_gecko_data.dart';
import 'package:rising_star_crypto_app/services/coin_gecko_service.dart';
import 'market_data_test.mocks.dart';
import 'market_data_test_data.dart';

@GenerateMocks([CoinGeckoData, CoinGeckoService])
main() {
  final coinGeckoData = MockCoinGeckoData();
  final MarketData marketData = MarketData(
    dateRange: DateTimeRange(
        start: DateTime.fromMillisecondsSinceEpoch(0), end: DateTime.now()),
    coin: Coin.bitcoin,
    currency: Currency.euro,
    database: coinGeckoData,
  );

  when(coinGeckoData.getDailyPricesWithinRange(
          coin: anyNamed('coin'),
          vsCurrency: anyNamed('vsCurrency'),
          from: anyNamed('from'),
          to: anyNamed('to')))
      .thenAnswer((_) => Future.value(dailyPricesData));

  when(coinGeckoData.getDailyTotalVolumesWithinRange(
          coin: anyNamed('coin'),
          vsCurrency: anyNamed('vsCurrency'),
          from: anyNamed('from'),
          to: anyNamed('to')))
      .thenAnswer((_) => Future.value(dailyPricesData));

  group('marketData', () {
    test('getBestBuySellTimes', () async {
      var bestBuySellTimes = await marketData.getBestBuySellTimes();

      expect(bestBuySellTimes.first.value, 1.0);
      expect(bestBuySellTimes.last.value, 600.0);
      expect(bestBuySellTimes.first.date, DateTime(2020, 1, 1));
      expect(bestBuySellTimes.last.date, DateTime(2020, 1, 4));
    });

    test('getHighestDailyTradingVolume', () async {
      var highestTradingVolume =
          await marketData.getHighestDailyTradingVolume();

      expect(highestTradingVolume.value, 700.0);
      expect(highestTradingVolume.date, DateTime(2019, 12, 31));
    });

    test('getLongestDownwardTrendWithinRange', () async {
      var trend = await marketData.getLongestDownwardTrendWithinRange();

      expect(trend.first.value, 600.0);
      expect(trend.first.date, DateTime(2020, 1, 4));
      expect(trend.last.value, 1.0);
      expect(trend.last.date, DateTime(2020, 1, 7));
    });
  });
}
