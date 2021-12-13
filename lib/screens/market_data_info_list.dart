import 'package:flutter/cupertino.dart';
import 'package:rising_star_crypto_app/common/bordeless_flat_card.dart';
import 'package:rising_star_crypto_app/data_widgets/buy_and_sell_info.dart';
import 'package:rising_star_crypto_app/data_widgets/highest_trading_volume_info.dart';
import 'package:rising_star_crypto_app/data_widgets/longest_trend_info.dart';
import 'package:rising_star_crypto_app/models/market_data.dart';

class MarketDataInfoList extends StatelessWidget {
  const MarketDataInfoList({
    Key? key,
    required this.marketData,
  }) : super(key: key);

  final MarketData marketData;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: const EdgeInsets.all(8.0),
      children: <Widget>[
        BordelessFlatCard(
          title: 'Higest trading volume',
          child: HighestTradingVolumeInfo(
            data: marketData.highestDailyTradingVolume,
            currency: marketData.currency,
          ),
        ),
        const SizedBox(
          height: 8.0,
        ),
        BordelessFlatCard(
          title: 'Longest downward trend',
          child: LongestTrendInfo(
            trend: marketData.longestDownwardTrend,
            currency: marketData.currency,
          ),
        ),
        const SizedBox(
          height: 8.0,
        ),
        BordelessFlatCard(
          title: 'Best time to buy and sell',
          child: BuyAndSellInfo(
            currency: marketData.currency,
            data: marketData.bestBuySellTimes,
          ),
        ),
        const SizedBox(
          height: 60.0,
        ),
      ],
    );
  }
}
