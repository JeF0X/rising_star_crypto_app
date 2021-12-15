import 'package:rising_star_crypto_app/models/date_value_data.dart';

import 'constants.dart';

class Helpers {
  /// Check if [dayA] and [dayB] are on the same day time
  static bool isSameDay(DateTime dayA, DateTime dayB) {
    if (dayA.day == dayB.day &&
        dayA.month == dayB.month &&
        dayA.year == dayB.year) {
      return true;
    }
    return false;
  }

  /// Get longest trend from [values]. Set [isDownward] to false for upwardTrend.
  static Future<List<DateValueData>> getLongestTrend({
    required List<DateValueData> values,
    bool isDownward = true,
  }) async {
    List<DateValueData> longestTrend = [];

    DateValueData lastEntry = DateValueData(
        DateTime.fromMillisecondsSinceEpoch(0, isUtc: true), -1.0);

    List<DateValueData> trend = [];

    for (var datapoint in values) {
      if (isDownward &&
          !Helpers.isSameDay(datapoint.date, lastEntry.date) &&
          datapoint.value < lastEntry.value) {
        if (trend.isEmpty) {
          trend.add(lastEntry);
        }
        trend.add(datapoint);
      } else if (!isDownward &&
          !Helpers.isSameDay(datapoint.date, lastEntry.date) &&
          datapoint.value > lastEntry.value) {
        if (trend.isEmpty) {
          trend.add(lastEntry);
        }
        trend.add(datapoint);
      } else {
        if (longestTrend.length < trend.length) {
          longestTrend = List.from(trend);
        }
        trend.clear();
      }
      lastEntry = datapoint;
    }
    if (trend.length > longestTrend.length) {
      longestTrend = trend;
    }
    return longestTrend;
  }

  /// Get string for [coin] matching CoinGecko API's coin [id]
  static String getCoinGeckoCoinString(Coin coin) {
    Map<Coin, String> coinGeckoCoins = {
      Coin.bitcoin: 'bitcoin',
      Coin.etherium: 'ethereum',
      Coin.binanceCoin: 'binance-coin',
    };
    return coinGeckoCoins[coin] ?? 'bitcoin';
  }

  /// Get string for [currency] matching CoinGecko API's [vs_currency]
  static String getCoinGeckoCurrencyString(Currency currency) {
    Map<Currency, String> coinGeckoCoins = {
      Currency.usDollar: 'usd',
      Currency.euro: 'eur',
      Currency.britishPound: 'gbp',
    };
    return coinGeckoCoins[currency] ?? 'usd';
  }

  /// Get coin name matching [coin]
  static String getCoinText(Coin coin) {
    switch (coin) {
      case Coin.bitcoin:
        return 'Bitcoin';
      case Coin.etherium:
        return 'Ehterium';
      default:
        return coin.toString();
    }
  }

  /// Get currency symbol matching [currency]
  static String getCurrencySymbol(Currency currency) {
    switch (currency) {
      case Currency.usDollar:
        return '\$';
      case Currency.euro:
        return '€';
      case Currency.britishPound:
        return '£';
      default:
        return currency.toString();
    }
  }

  /// Get currency name matching [currency]
  static String getCurrencyText(Currency currency) {
    switch (currency) {
      case Currency.usDollar:
        return 'Dollars (USD)';
      case Currency.euro:
        return 'Euros (EUR)';
      case Currency.britishPound:
        return 'Pounds (GBP)';
      default:
        return currency.toString();
    }
  }
}
