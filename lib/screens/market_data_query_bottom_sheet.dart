import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rising_star_crypto_app/common/app_colors.dart';
import 'package:rising_star_crypto_app/common/constants.dart';
import 'package:rising_star_crypto_app/common/helpers.dart';
import 'package:rising_star_crypto_app/common/minimal_dropdown_button.dart';
import 'package:rising_star_crypto_app/common/text_field_date_picker.dart';
import 'package:rising_star_crypto_app/models/market_data.dart';

class MarketDataQueryBottomSheet extends StatelessWidget {
  final MarketData marketData;
  final Function onDataChanged;
  const MarketDataQueryBottomSheet(
      {Key? key, required this.marketData, required this.onDataChanged})
      : super(key: key);

  void _onEndDatePressed(DateTime date) {
    var startDate = marketData.dateRange.start.isBefore(date)
        ? marketData.dateRange.start
        : date.subtract(
            const Duration(days: 1),
          );
    marketData.dateRange = DateTimeRange(start: startDate, end: date);
    onDataChanged();
  }

  void _onStartDatePressed(DateTime date) {
    var endDate = marketData.dateRange.end.isAfter(date)
        ? marketData.dateRange.end
        : date.add(
            const Duration(days: 1),
          );
    marketData.dateRange = DateTimeRange(start: date, end: endDate);
    onDataChanged();
  }

  @override
  Widget build(BuildContext context) {
    DateTime? initialStartDate = marketData.dateRange.start
            .isAfter(DateTime.fromMicrosecondsSinceEpoch(0))
        ? marketData.dateRange.start
        : null;

    return DraggableScrollableSheet(
      initialChildSize: kIsWeb ? 0.22 : 0.1,
      minChildSize: kIsWeb ? 0.22 : 0.1,
      maxChildSize: kIsWeb ? 0.22 : 0.22,
      snap: true,
      builder: (BuildContext context, ScrollController controller) {
        return Container(
          decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary,
                  spreadRadius: 20,
                  blurRadius: 20,
                  offset: const Offset(0, 3),
                ),
              ]),
          child: ListView(
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            padding:
                const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
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
                  TextFieldDatePicker(
                    initialDate: initialStartDate,
                    onPressed: (date) => _onStartDatePressed(date),
                  ),
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
                    onPressed: (date) => _onEndDatePressed(date),
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
                        menuItemChild: (value) =>
                            Helpers.getCurrencyText(value),
                        onChanged: (value) {
                          marketData.currency = value;
                          onDataChanged();
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
                        menuItemChild: (value) => Helpers.getCoinText(value),
                        onChanged: (value) {
                          marketData.coin = value;
                          onDataChanged();
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
    );
  }
}
