enum Currency {
  eur,
  usd,
  gbp,
}

enum Coin {
  btc,
  eth,
  bnb,
}

enum MarketDataOptions {
  longestDownwardTrend,
  bestBuySell,
  highestTradingVolume,
}

String coinGeckoCoins(Coin coin) {
  Map<Coin, String> coinGeckoCoins = {
    Coin.btc: 'bitcoin',
    Coin.eth: 'ethereum',
    Coin.bnb: 'binance-coin',
  };
  return coinGeckoCoins[coin] ?? 'bitcoin';
}

String coinGeckoCurrencies(Currency currency) {
  Map<Currency, String> coinGeckoCoins = {
    Currency.usd: 'usd',
    Currency.eur: 'eur',
    Currency.gbp: 'gbp',
  };
  return coinGeckoCoins[currency] ?? 'usd';
}

String getCoinText(Coin coin) {
  switch (coin) {
    case Coin.btc:
      return 'Bitcoin';
    case Coin.eth:
      return 'Ehterium';
    default:
      return coin.toString();
  }
}

String getCurrencySymbol(Currency currency) {
  switch (currency) {
    case Currency.usd:
      return '\$';
    case Currency.eur:
      return '€';
    case Currency.gbp:
      return '£';
    default:
      return currency.toString();
  }
}

String getCurrencyText(Currency currency) {
  switch (currency) {
    case Currency.usd:
      return 'Dollars (USD)';
    case Currency.eur:
      return 'Euros (EUR)';
    case Currency.gbp:
      return 'Pounds (GBP)';
    default:
      return currency.toString();
  }
}
