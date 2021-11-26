abstract class CryptoData {
  Future<Map<DateTime, double>> getDailyPricesWithinRange({
    required String coin,
    required String vsCurrency,
    required DateTime from,
    required DateTime to,
  });
  Future<Map<DateTime, double>> getDailyMarketCapsWithinRange({
    required String coin,
    required String vsCurrency,
    required DateTime from,
    required DateTime to,
  });
  Future<Map<DateTime, double>> getDailyTotalVolumesWithinRange({
    required String coin,
    required String vsCurrency,
    required DateTime from,
    required DateTime to,
  });
}
