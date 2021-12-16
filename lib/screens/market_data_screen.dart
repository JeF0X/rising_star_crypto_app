import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
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
        start: DateTime.fromMicrosecondsSinceEpoch(0).toUtc(),
        end: DateTime.now().toUtc()),
    coin: Coin.bitcoin,
    currency: Currency.euro,
  );

  bool isDataChanged = true;
  bool isLoading = false;
  bool isStartDateAtEpoch = false;
  String errorText = 'Pick a start date';

  _onDataChanged() {
    setState(() {
      errorText = '';
      isStartDateAtEpoch = true;
      isDataChanged = true;
    });
  }

  _onRefreshButtonPressed() async {
    setState(() {
      errorText = '';
      isLoading = true;
    });
    try {
      await marketData.updateMarketData();
    } on HttpException catch (e) {
      setState(() {
        isLoading = false;
        errorText = e.message;
      });
      log(e.message);
      return;
    } catch (e) {
      setState(() {
        isLoading = false;
        errorText = 'Error parsing data';
      });

      log(e.toString());
      return;
    }

    setState(() {
      errorText = '';
      marketData;
      isLoading = false;
      isDataChanged = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    isStartDateAtEpoch = !marketData.dateRange.start
        .isAfter(DateTime.fromMicrosecondsSinceEpoch(0).toUtc());
    return Expanded(
      child: Stack(
        alignment: Alignment.topCenter,
        fit: StackFit.loose,
        children: [
          Stack(
            alignment: Alignment.topCenter,
            fit: StackFit.loose,
            children: [
              SizedBox(
                  width: kIsWeb ? 500 : null,
                  child: MarketDataInfoList(marketData: marketData)),
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
                      Text(
                        errorText,
                        style: TextStyle(color: Colors.red.shade900),
                      ),
                      isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              child: const Text('REFRESH DATA'),
                              onPressed: isStartDateAtEpoch
                                  ? null
                                  : _onRefreshButtonPressed,
                            ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 4,
                      ),
                    ],
                  ),
                ),
          Align(
            alignment: AlignmentDirectional.bottomCenter,
            child: MarketDataQueryBottomSheet(
                marketData: marketData, onDataChanged: _onDataChanged),
          )
        ],
      ),
    );
  }
}
