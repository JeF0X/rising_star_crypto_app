import 'package:flutter/material.dart';
import 'package:rising_star_crypto_app/common/constants.dart';
import 'package:rising_star_crypto_app/common/date_value_info.dart';
import 'package:rising_star_crypto_app/models/date_value.dart';

class LongestTrendInfo extends StatelessWidget {
  final List<DateValueData> trend;
  final Currency currency;

  const LongestTrendInfo({
    Key? key,
    required this.trend,
    required this.currency,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool hasData = trend.length > 1;
    return !hasData
        ? const Text(
            'No downward trends during the time period. Please select a different date range.',
            style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DateValueInfo(
                dateValue: trend.isNotEmpty ? trend.first : null,
                title: 'FROM',
                valueSymbol: getCurrencySymbol(currency),
              ),
              Divider(
                thickness: 2.0,
                color: Colors.grey.shade400,
              ),
              DateValueInfo(
                dateValue: trend.isNotEmpty ? trend.last : null,
                title: 'TO',
                valueSymbol: getCurrencySymbol(currency),
              ),
              const Divider(
                thickness: 2.0,
                color: Colors.white38,
              ),
              Text(
                '${trend.length - 1} days',
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),
              ),
            ],
          );
  }
}
