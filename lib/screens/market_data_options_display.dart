import 'package:flutter/material.dart';
import 'package:rising_star_crypto_app/common/constants.dart';
import 'package:rising_star_crypto_app/common/minimal_dropdown_button.dart';
import 'package:rising_star_crypto_app/data_widgets/buy_and_sell_info.dart';
import 'package:rising_star_crypto_app/data_widgets/highest_trading_volume_info.dart';
import 'package:rising_star_crypto_app/data_widgets/longest_trend_info.dart';
import 'package:rising_star_crypto_app/models/date_value.dart';
import 'package:rising_star_crypto_app/models/market_data.dart';

class MarketDataOptionsDisplay extends StatefulWidget {
  final MarketData? marketData;
  final Widget? child;
  final bool isDataChanged;
  const MarketDataOptionsDisplay(
      {Key? key,
      required this.marketData,
      required this.child,
      required this.isDataChanged})
      : super(key: key);

  @override
  State<MarketDataOptionsDisplay> createState() =>
      _MarketDataOptionsDisplayState();
}

class _MarketDataOptionsDisplayState extends State<MarketDataOptionsDisplay> {
  MarketDataOptions dataDropdownValue = MarketDataOptions.highestTradingVolume;
  DateValueData? highestTradingVolume;
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    if (widget.marketData == null) {
      return const SizedBox();
    }

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 22, 26, 45),
          borderRadius: BorderRadius.circular(15.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: MinimalDropDownButton<MarketDataOptions>(
              value: dataDropdownValue,
              onChanged: (newValue) async {
                if (widget.marketData != null) {
                  setState(() {
                    dataDropdownValue = newValue;
                  });
                }
              },
              values: MarketDataOptions.values,
              menuItemChild: (value) => getMarketDataOptionsText(value),
            ),
          ),
          // Data info
          Stack(
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                foregroundDecoration: widget.isDataChanged
                    ? BoxDecoration(
                        color: Colors.black.withAlpha(100),
                        borderRadius: BorderRadius.circular(15.0))
                    : BoxDecoration(borderRadius: BorderRadius.circular(15.0)),
                decoration: const BoxDecoration(),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: _buildInfoWidget(dataDropdownValue, widget.marketData),
                ),
              ),
              Center(
                child: widget.child,
              )
            ],
          ),
        ],
      ),
    );
  }

  String getMarketDataOptionsText(MarketDataOptions option) {
    switch (option) {
      case MarketDataOptions.highestTradingVolume:
        return 'Highest trading volume';
      case MarketDataOptions.bestBuySell:
        return 'Best times to buy and sell';
      case MarketDataOptions.longestDownwardTrend:
        return 'Longest downward trend';
      default:
        return 'Unknown option';
    }
  }

  _buildInfoWidget(MarketDataOptions option, MarketData? marketData) {
    if (marketData == null) {
      return const Text('No data');
    }
    switch (option) {
      case MarketDataOptions.bestBuySell:
        return BuyAndSellInfo(
          currency: marketData.currency,
          data: marketData.bestBuySellTimes,
        );
      case MarketDataOptions.highestTradingVolume:
        return HighestTradingVolumeInfo(
            currency: marketData.currency,
            data: marketData.highestDailyTradingVolume);
      case MarketDataOptions.longestDownwardTrend:
        return LongestTrendInfo(
          trend: marketData.longestDownwardTrend,
          currency: marketData.currency,
        );
      default:
        const Text('No data');
    }
  }
}
