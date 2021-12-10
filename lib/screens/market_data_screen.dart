import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:rising_star_crypto_app/common/bordeless_flat_card.dart';
import 'package:rising_star_crypto_app/common/constants.dart';
import 'package:rising_star_crypto_app/common/minimal_dropdown_button.dart';
import 'package:rising_star_crypto_app/common/text_field_date_picker.dart';
import 'package:rising_star_crypto_app/data_widgets/buy_and_sell_info.dart';
import 'package:rising_star_crypto_app/data_widgets/highest_trading_volume_info.dart';
import 'package:rising_star_crypto_app/data_widgets/longest_trend_info.dart';
import 'package:rising_star_crypto_app/models/market_data.dart';

class MarketDataScreen extends StatefulWidget {
  const MarketDataScreen({Key? key}) : super(key: key);

  @override
  State<MarketDataScreen> createState() => _MarketDataScreenState();
}

class _MarketDataScreenState extends State<MarketDataScreen> {
  MarketData marketData = MarketData(
    dateTimeRange: DateTimeRange(
        start: DateTime.fromMicrosecondsSinceEpoch(0), end: DateTime.now()),
    coin: Coin.btc,
    currency: Currency.usd,
  );
  bool isDataChanged = true;
  bool isLoading = false;
  bool isStartDateAtEpoch = false;
  @override
  Widget build(BuildContext context) {
    isStartDateAtEpoch = !marketData.dateRange.start
        .isAfter(DateTime.fromMicrosecondsSinceEpoch(0));
    return Expanded(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child: Text(
                  getCoinText(marketData.coin),
                  style: const TextStyle(fontSize: 16.0, color: Colors.white60),
                ),
              ),
              Expanded(
                child: Stack(
                  fit: StackFit.loose,
                  children: [
                    _buildInfoCards(),
                    !isDataChanged
                        ? const SizedBox()
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            clipBehavior: Clip.antiAlias,
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 10.0,
                                sigmaY: 10.0,
                              ),
                              child: Container(),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
          !isDataChanged
              ? const SizedBox()
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildRefreshButton(),
                      isStartDateAtEpoch
                          ? Text(
                              'Pick a valid date range',
                              style: TextStyle(color: Colors.red.shade900),
                            )
                          : const SizedBox(),
                      const SizedBox(height: 150.0),
                    ],
                  ),
                ),
          DraggableScrollableSheet(
            initialChildSize: 0.1,
            minChildSize: 0.1,
            maxChildSize: 0.20,
            snap: true,
            builder: (BuildContext context, ScrollController controller) {
              return Container(
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 30, 47, 69),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25.0),
                        topRight: Radius.circular(25.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(14, 17, 31, 0.9),
                        spreadRadius: 20,
                        blurRadius: 20,
                        offset: Offset(0, 3),
                      ),
                    ]),
                child: ListView(
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(
                      left: 16.0, right: 16.0, bottom: 16.0),
                  controller: controller,
                  children: [
                    const Divider(
                      color: Colors.white60,
                      thickness: 2.0,
                      indent: 150.0,
                      endIndent: 150.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // const Text(
                        //   'from: ',
                        //   style: TextStyle(
                        //     fontSize: 16.0,
                        //     fontWeight: FontWeight.bold,
                        //     color: Colors.white60,
                        //   ),
                        // ),
                        TextFieldDatePicker(
                          initialDate: marketData.dateRange.start.isAfter(
                                  DateTime.fromMicrosecondsSinceEpoch(0))
                              ? marketData.dateRange.start
                              : null,
                          onPressed: (date) async {
                            setState(() {
                              isStartDateAtEpoch = true;
                              isDataChanged = true;
                              marketData.dateRange = DateTimeRange(
                                  start: date, end: marketData.dateRange.end);
                            });
                          },
                        ),
                        // const SizedBox(
                        //   width: 30.0,
                        // ),
                        const Text(
                          'TO',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white60,
                          ),
                        ),
                        TextFieldDatePicker(
                          initialDate: marketData.dateRange.end,
                          onPressed: (date) async {
                            setState(() {
                              isDataChanged = true;
                              marketData.dateRange = DateTimeRange(
                                  start: marketData.dateRange.start, end: date);
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Currency',
                              style: TextStyle(color: Colors.white60),
                            ),
                            MinimalDropDownButton<Currency>(
                              value: marketData.currency,
                              values: Currency.values,
                              menuItemChild: (value) => getCurrencyText(value),
                              onChanged: (value) {
                                setState(() {
                                  isDataChanged = true;
                                  marketData.currency = value;
                                });
                              },
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Coin',
                              style: TextStyle(color: Colors.white60),
                            ),
                            MinimalDropDownButton<Coin>(
                              value: marketData.coin,
                              values: Coin.values,
                              menuItemChild: (value) => getCoinText(value),
                              onChanged: (value) {
                                setState(() {
                                  isDataChanged = true;
                                  marketData.coin = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  ListView _buildInfoCards() {
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

  Widget _buildRefreshButton() {
    if (isLoading) {
      return const CircularProgressIndicator();
    }
    if (isDataChanged) {
      return ElevatedButton(
        child: const Text('REFRESH DATA'),
        onPressed: isStartDateAtEpoch
            ? null
            : () async {
                setState(() {
                  isLoading = true;
                });
                await marketData.updateMarketData();
                setState(() {
                  marketData;
                  isLoading = false;
                  isDataChanged = false;
                });
              },
      );
    }
    return const SizedBox();
  }
}
