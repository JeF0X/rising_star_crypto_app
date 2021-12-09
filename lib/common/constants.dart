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
      return 'Bitcoin (BTC)';
    case Coin.eth:
      return 'Ehterium (EHT)';
    default:
      return coin.toString();
  }
}

String getCurrencyText(Currency currency) {
  switch (currency) {
    case Currency.usd:
      return 'US Dollars (USD)';
    case Currency.eur:
      return 'Euros (EUR)';
    default:
      return currency.toString();
  }
}
