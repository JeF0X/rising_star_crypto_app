import 'dart:developer';

import 'package:flutter/material.dart';
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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  var endTime =
      DateTime.fromMillisecondsSinceEpoch(1621468800 * 1000, isUtc: true);

  int day = 1;
  int month = 1;
  int year = 0;
  String longestDownwardTrendText = '';

  Future<void> _highestTradingVolume(DateTime startTime) async {
    var data = CoinGeckoData.instance;
    try {
      var tradingVolumes = await data.getDailyTotalVolumesWithinRange(
          coin: coin, vsCurrency: currency, from: startTime, to: endTime);
      var highestTradingVolume =
          MarketChartData.getHighestDailyTradingVolume(tradingVolumes);
      log('Highest trading volume was ${highestTradingVolume.value.toString()} on ${highestTradingVolume.key.toString()}');
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _longestDownwardTrend(DateTime startTime) async {
    var data = CoinGeckoData.instance;
    try {
      var prices = await data.getDailyPricesWithinRange(
          coin: coin, vsCurrency: currency, from: startTime, to: endTime);
      var longestDownwardTrend =
          MarketChartData.getLongestDownwardTrendWithinRange(prices);

      log('Longest downward trend of ${longestDownwardTrend.length - 1} days between $startTime and $endTime was from ${longestDownwardTrend.keys.first} to ${longestDownwardTrend.keys.last}');

      setState(() {
        longestDownwardTrendText =
            'Longest downward trend of ${longestDownwardTrend.length - 1} days between ${prices.keys.first} and ${prices.keys.last} was from ${longestDownwardTrend.keys.first} to ${longestDownwardTrend.keys.last}';
      });
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> _bestTimeToBuyAndSell(DateTime startTime) async {
    var data = CoinGeckoData.instance;
    try {
      var prices = await data.getDailyPricesWithinRange(
          coin: coin, vsCurrency: currency, from: startTime, to: endTime);
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(hintText: '23'),
              onChanged: (value) {
                day = int.tryParse(value) ?? 1;
              },
            ),
            TextField(
              decoration: const InputDecoration(hintText: '12'),
              onChanged: (value) {
                month = int.tryParse(value) ?? 12;
              },
            ),
            TextField(
              decoration: const InputDecoration(hintText: '2020'),
              onChanged: (value) {
                year = int.tryParse(value) ?? 2020;
              },
            ),
            Text(
              longestDownwardTrendText,
            ),
            TextButton(
              onPressed: () => _onPressed(),
              child: const Text('Test Downward Trend'),
            ),
          ],
        ),
      ),
    );
  }

  void _onPressed() async {
    await _highestTradingVolume(DateTime.utc(year, month, day));
    await _longestDownwardTrend(DateTime.utc(year, month, day));
    await _bestTimeToBuyAndSell(DateTime.utc(year, month, day));
  }
}
