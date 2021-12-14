import 'package:flutter/material.dart';

enum Currency {
  euro,
  usDollar,
  britishPound,
}

enum Coin {
  bitcoin,
  etherium,
  binanceCoin,
}

enum MarketDataOptions {
  longestDownwardTrend,
  bestBuySell,
  highestTradingVolume,
}

class AppColors {
  static Color primary = const Color.fromARGB(255, 14, 17, 31);
  static Color secondary = const Color.fromARGB(255, 30, 47, 69);
  static Color select = const Color.fromARGB(255, 22, 26, 45);
  static Color highLight = const Color.fromARGB(255, 71, 112, 166);
}

String coinGeckoCoins(Coin coin) {
  Map<Coin, String> coinGeckoCoins = {
    Coin.bitcoin: 'bitcoin',
    Coin.etherium: 'ethereum',
    Coin.binanceCoin: 'binance-coin',
  };
  return coinGeckoCoins[coin] ?? 'bitcoin';
}

String coinGeckoCurrencies(Currency currency) {
  Map<Currency, String> coinGeckoCoins = {
    Currency.usDollar: 'usd',
    Currency.euro: 'eur',
    Currency.britishPound: 'gbp',
  };
  return coinGeckoCoins[currency] ?? 'usd';
}

String getCoinText(Coin coin) {
  switch (coin) {
    case Coin.bitcoin:
      return 'Bitcoin';
    case Coin.etherium:
      return 'Ehterium';
    default:
      return coin.toString();
  }
}

String getCurrencySymbol(Currency currency) {
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

String getCurrencyText(Currency currency) {
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
