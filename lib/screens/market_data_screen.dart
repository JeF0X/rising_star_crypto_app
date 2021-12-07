import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:rising_star_crypto_app/common/text_field_date_picker.dart';
import 'package:rising_star_crypto_app/data_widgets/buy_and_sell_info.dart';
import 'package:rising_star_crypto_app/data_widgets/highest_trading_volume_info.dart';
import 'package:rising_star_crypto_app/data_widgets/longest_trend_info.dart';
import 'package:rising_star_crypto_app/models/date_value.dart';
import 'package:rising_star_crypto_app/models/market_data.dart';

class MarketDataScreen extends StatefulWidget {
  const MarketDataScreen({Key? key}) : super(key: key);

  @override
  State<MarketDataScreen> createState() => _MarketDataScreenState();
}

class _MarketDataScreenState extends State<MarketDataScreen> {
  void _onPressed(MarketData marketData) async {
    await _setData(marketData);
    // await _longestDownwardTrend(marketData);
    // await _bestTimeToBuyAndSell(marketData);
  }

  var downwardTrendLenght = 0;
  var coin = 'bitcoin';
  var currency = 'usd';
  DateTime? startDate;
  DateTime endDate = DateTime.now();
  String longestDownwardTrendText = '';
  String dropdownValue = 'Longest downward trend';
  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();

  DateValueData? highestTradingVolume;
  List<DateValueData> longestDownwardTrend = [];
  List<DateValueData> bestBuySellTimes = [];

  bool isLoading = false;

  Future<void> _setData(MarketData marketData) async {
    setState(() {
      highestTradingVolume = null;
      longestDownwardTrend.clear();
      bestBuySellTimes.clear();
      isLoading = true;
    });

    try {
      var _highestTradingVolume =
          await marketData.getHighestDailyTradingVolume();
      var _longestDownwardTrend =
          await marketData.getLongestDownwardTrendWithinRange();
      var _bestBuySellTimes = await marketData.calculateBestBuySellTimes();
      setState(() {
        highestTradingVolume = _highestTradingVolume;
        longestDownwardTrend = _longestDownwardTrend;
        bestBuySellTimes = _bestBuySellTimes;
      });
    } catch (e) {
      log(e.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: TextFieldDatePicker(
                    controller: fromController,
                    initialDate: startDate,
                    onPressed: (date) async {
                      setState(() {
                        startDate = date;
                        fromController.text =
                            '${date.day}/${date.month}/${date.year}';
                      });
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '-',
                    style: TextStyle(fontSize: 32.0),
                  ),
                ),
                Expanded(
                  child: TextFieldDatePicker(
                    controller: toController,
                    initialDate: endDate,
                    onPressed: (date) async {
                      setState(() {
                        endDate = date;
                        toController.text =
                            '${date.day}/${date.month}/${date.year}';
                      });
                    },
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(border: Border.all()),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      isExpanded: true,
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                      isDense: true,
                      underline: Container(
                        height: 1.0,
                        color: Colors.transparent,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                      items: <String>[
                        'Longest downward trend',
                        'Highest trading volume',
                        'Best days to buy and sell',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(fontSize: 18.0),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Container(
                    decoration: (const BoxDecoration(
                        border: Border(top: BorderSide()))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BuyAndSellInfo(
                        buyData: bestBuySellTimes.isNotEmpty
                            ? bestBuySellTimes.first
                            : null,
                        sellData: bestBuySellTimes.isNotEmpty
                            ? bestBuySellTimes.last
                            : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              decoration: BoxDecoration(border: Border.all()),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: HighestTradingVolumeInfo(
                  data: highestTradingVolume,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Container(
              decoration: BoxDecoration(border: Border.all()),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: LongestTrendInfo(
                  trend: longestDownwardTrend,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: (startDate == null || isLoading)
                  ? null
                  : () => _onPressed(
                        MarketData(
                          dateTimeRange: DateTimeRange(
                            start: startDate!,
                            end: endDate,
                          ),
                          coin: coin,
                          currency: currency,
                        ),
                      ),
              child: const Text('SEARCH'),
            ),
          ],
        ),
        isLoading
            ? const Center(child: CircularProgressIndicator())
            : const SizedBox()
      ],
    );
  }
}
