import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:rising_star_crypto_app/common/date_price_info.dart';
import 'package:rising_star_crypto_app/common/text_field_date_picker.dart';
import 'package:rising_star_crypto_app/models/market_chart_data.dart';
import 'package:rising_star_crypto_app/services/coin_gecko_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Scrooge\'s Crypto App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var downwardTrendLenght = 0;

  var coin = 'bitcoin';
  var currency = 'usd';
  DateTime? startDate;
  DateTime endDate = DateTime.now();
  String longestDownwardTrendText = '';
  String dropdownValue = 'Longest downward trend';

  TextEditingController fromController = TextEditingController();
  TextEditingController toController = TextEditingController();

  Future<void> _highestTradingVolume(DateTimeRange timeRange) async {
    var data = CoinGeckoData.instance;
    try {
      var tradingVolumes = await data.getDailyTotalVolumesWithinRange(
          coin: coin,
          vsCurrency: currency,
          from: timeRange.start,
          to: timeRange.end);
      var highestTradingVolume =
          MarketChartData.getHighestDailyTradingVolume(tradingVolumes);
      log('Highest trading volume was ${highestTradingVolume.value.toString()} on ${highestTradingVolume.date.toString()}');
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _longestDownwardTrend(DateTimeRange timeRange) async {
    var data = CoinGeckoData.instance;
    try {
      var prices = await data.getDailyPricesWithinRange(
          coin: coin,
          vsCurrency: currency,
          from: timeRange.start,
          to: timeRange.end);
      var longestDownwardTrend =
          MarketChartData.getLongestDownwardTrendWithinRange(prices);

      log('Longest downward trend of ${longestDownwardTrend.length - 1} days between ${timeRange.start} and $endDate was from ${longestDownwardTrend.first.date} to ${longestDownwardTrend.last.date}');

      setState(() {
        longestDownwardTrendText =
            'Longest downward trend of ${longestDownwardTrend.length - 1} days between ${prices.first.date} and ${prices.last.date} was from ${longestDownwardTrend.first.date} to ${longestDownwardTrend.last.date}';
      });
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _bestTimeToBuyAndSell(DateTimeRange timeRange) async {
    var data = CoinGeckoData.instance;
    try {
      var prices = await data.getDailyPricesWithinRange(
          coin: coin,
          vsCurrency: currency,
          from: timeRange.start,
          to: timeRange.end);
      MarketChartData.calculateBestBuySellTimes(prices);
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
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
                        child: Column(
                          children: [
                            DatePriceInfo(
                              date: DateTime.now(),
                              price: 232.0,
                              title: 'BUY',
                            ),
                            Divider(
                              thickness: 2.0,
                              color: Colors.grey.shade400,
                            ),
                            DatePriceInfo(
                              date: DateTime.now(),
                              price: 435.0,
                              title: 'SELL',
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              ElevatedButton(
                onPressed:
                    startDate == null ? null : () => _onPressed(startDate!),
                child: const Text('TEST'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onPressed(DateTime startDate) async {
    await _highestTradingVolume(DateTimeRange(start: startDate, end: endDate));
    await _longestDownwardTrend(DateTimeRange(start: startDate, end: endDate));
    await _bestTimeToBuyAndSell(DateTimeRange(start: startDate, end: endDate));
  }
}
