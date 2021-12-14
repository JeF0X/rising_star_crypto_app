import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:rising_star_crypto_app/common/constants.dart';
import 'package:rising_star_crypto_app/models/market_data.dart';
import 'package:rising_star_crypto_app/screens/market_data_info_list.dart';
import 'package:rising_star_crypto_app/screens/market_data_query_bottom_sheet.dart';

class MarketDataScreen extends StatefulWidget {
  const MarketDataScreen({Key? key}) : super(key: key);

  @override
  State<MarketDataScreen> createState() => _MarketDataScreenState();
}

class _MarketDataScreenState extends State<MarketDataScreen> {
  MarketData marketData = MarketData(
    dateRange: DateTimeRange(
        start: DateTime.fromMicrosecondsSinceEpoch(0), end: DateTime.now()),
    coin: Coin.bitcoin,
    currency: Currency.usDollar,
  );

  bool isDataChanged = true;
  bool isLoading = false;
  bool isStartDateAtEpoch = false;
  String errorText = 'Pick a start date';

  @override
  Widget build(BuildContext context) {
    isStartDateAtEpoch = !marketData.dateRange.start
        .isAfter(DateTime.fromMicrosecondsSinceEpoch(0));
    return Expanded(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Stack(
            fit: StackFit.loose,
            children: [
              MarketDataInfoList(marketData: marketData),
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
          !isDataChanged
              ? const SizedBox()
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              child: const Text('REFRESH DATA'),
                              onPressed: isStartDateAtEpoch
                                  ? null
                                  : _onRefreshButtonPressed,
                            ),
                      const SizedBox(
                        height: 150,
                      ),
                    ],
                  ),
                ),
          MarketDataQueryBottomSheet(
              marketData: marketData, onDataChanged: _onDataChanged)
        ],
      ),
    );
  }

  _onDataChanged() {
    setState(() {
      errorText = '';
      isStartDateAtEpoch = true;
      isDataChanged = true;
    });
  }

  _onRefreshButtonPressed() async {
    setState(() {
      isLoading = true;
    });
    await marketData.updateMarketData();
    setState(() {
      marketData;
      isLoading = false;
      isDataChanged = false;
    });
  }
}
