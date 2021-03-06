import 'package:flutter/material.dart';
import 'package:rising_star_crypto_app/market_data_screen/market_data_screen.dart';

import 'common/app_colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColorLight: Colors.amber,
          canvasColor: AppColors.secondary,
          dialogBackgroundColor: AppColors.primary,
          colorScheme: ColorScheme.dark(
            primary: AppColors.highLight,
            primaryVariant: AppColors.highLight,
            secondary: AppColors.secondary,
            surface: AppColors.secondary,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              primary: const Color.fromARGB(255, 48, 59, 107),
              onPrimary: Colors.white,
              onSurface: Colors.white,
            ),
          ),
          textTheme: TextTheme(
            bodyText1: TextStyle(color: Colors.grey.shade300),
            bodyText2: TextStyle(color: Colors.grey.shade300),
            subtitle1: TextStyle(color: Colors.grey.shade300),
          ),
        ),
        home: ScrollConfiguration(
          behavior: NoGlowScrollBehaviour(),
          child: Scaffold(
            backgroundColor: const Color.fromARGB(255, 14, 17, 31),
            body: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: const [
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0, top: 16.0),
                    child: Text(
                      'Scrooge\'s Crypto App',
                      style: TextStyle(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  MarketDataScreen(),
                ],
              ),
            ),
          ),
        ));
  }
}

class NoGlowScrollBehaviour extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
