import 'package:flutter/material.dart';
import 'package:rising_star_crypto_app/common/constants.dart';
import 'package:rising_star_crypto_app/common/minimal_dropdown_button.dart';
import 'package:rising_star_crypto_app/common/text_field_date_picker.dart';
import 'package:rising_star_crypto_app/models/market_data.dart';
import 'package:rising_star_crypto_app/screens/market_data_options_display.dart';

class MarketDataScreen extends StatefulWidget {
  const MarketDataScreen({Key? key}) : super(key: key);

  @override
  State<MarketDataScreen> createState() => _MarketDataScreenState();
}

class _MarketDataScreenState extends State<MarketDataScreen> {
  MarketData marketData = MarketData(
    dateTimeRange: DateTimeRange(start: DateTime.now(), end: DateTime.now()),
    coin: Coin.btc,
    currency: Currency.usd,
  );
  bool isDataChanged = false;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
            Row(
              children: [
                Expanded(
                  child: TextFieldDatePicker(
                    initialDate: marketData.dateRange.start,
                    onPressed: (date) async {
                      setState(() {
                        isDataChanged = true;
                        marketData.dateRange = DateTimeRange(
                            start: date, end: marketData.dateRange.end);
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
                    initialDate: marketData.dateRange.end,
                    onPressed: (date) async {
                      setState(() {
                        isDataChanged = true;
                        marketData.dateRange = DateTimeRange(
                            start: marketData.dateRange.start, end: date);
                      });
                    },
                  ),
                ),
              ],
            ),
            MarketDataOptionsDisplay(
              marketData: marketData,
              isDataChanged: isDataChanged,
              child: _buildChild(),
            ),
          ],
        ),
      ],
    );
  }

  Widget? _buildChild() {
    if (isLoading) {
      return const CircularProgressIndicator();
    }
    if (isDataChanged) {
      return ElevatedButton(
        child: Text('REFRESH'),
        onPressed: () async {
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
    return null;
  }
}
