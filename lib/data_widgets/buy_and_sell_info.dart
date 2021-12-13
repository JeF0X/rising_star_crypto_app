import 'package:flutter/material.dart';
import 'package:rising_star_crypto_app/common/constants.dart';
import 'package:rising_star_crypto_app/common/date_value_info.dart';
import 'package:rising_star_crypto_app/models/date_value.dart';

class BuyAndSellInfo extends StatelessWidget {
  final List<DateValueData> data;
  final Currency currency;

  const BuyAndSellInfo({
    Key? key,
    required this.data,
    required this.currency,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool hasNoData = data.length < 2;
    var payoutRatio = 0.0;
    if (!hasNoData) {
      payoutRatio = data.last.value / data.first.value;
    }

    return hasNoData
        ? const Text(
            'No best buy and sell dates found. Select a different date range.',
            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DateValueInfo(
                dateValue: hasNoData ? null : data.first,
                title: 'BUY',
                valueSymbol: getCurrencySymbol(currency),
              ),
              Divider(
                thickness: 2.0,
                color: Colors.grey.shade400,
              ),
              DateValueInfo(
                dateValue: hasNoData ? null : data.last,
                title: 'SELL',
                valueSymbol: getCurrencySymbol(currency),
              ),
              const Divider(
                thickness: 2.0,
                color: Colors.white30,
              ),
              Text(
                'Payout ratio: ${payoutRatio.toStringAsFixed(2)}',
                textAlign: TextAlign.end,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          );
  }
}
