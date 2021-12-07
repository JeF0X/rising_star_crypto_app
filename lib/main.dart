import 'package:flutter/material.dart';
import 'package:rising_star_crypto_app/screens/market_data_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Scrooge\'s Crypto App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Scrooge\'s Crypto App'),
          ),
          body: const SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: MarketDataScreen(),
            ),
          ),
        ));
  }
}
