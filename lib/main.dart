import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:rising_star_crypto_app/models/market_chart.dart';
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
  int _counter = 0;
  var downwardTrendLenght = 0;
  var endTime = '';

  int day = 1;
  int month = 1;
  int year = 0;

  void _longestDownwardTrend(DateTime startTime) async {
    var marketChart = MarketChart(
      coin: 'bitcoin',
      currency: 'usd',
      startTime: startTime,
      endTime:
          DateTime.fromMillisecondsSinceEpoch(1637673569 * 1000, isUtc: true),
    );

    var data = CoinGeckoData.instance;
    var prices = await data.getPricesWithinRange(marketChart);
    var longestDownwardTrend =
        marketChart.longestDownwardTrendWithinRange(prices);

    log('Longest downward trend of ${longestDownwardTrend.length} days between ${marketChart.startTime} and ${marketChart.endTime} was from ${longestDownwardTrend.keys.first} to ${longestDownwardTrend.keys.last}');

    setState(() {
      _counter++;
    });
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
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            TextButton(
              onPressed: () => _longestDownwardTrend(
                DateTime.utc(year, month, day),
              ),
              child: Text('test'),
            ),
          ],
        ),
      ),
    );
  }
}
