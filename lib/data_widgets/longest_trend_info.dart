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
    return Column(
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
      ],
    );
  }
}
