import 'package:flutter/material.dart';
import 'package:rising_star_crypto_app/common/date_price_info.dart';
import 'package:rising_star_crypto_app/models/date_value.dart';

class LongestTrendInfo extends StatelessWidget {
  final List<DateValueData> trend;

  const LongestTrendInfo({
    Key? key,
    required this.trend,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DateValueInfo(
          dateValue: trend.isNotEmpty ? trend.first : null,
          title: 'FROM',
        ),
        Divider(
          thickness: 2.0,
          color: Colors.grey.shade400,
        ),
        DateValueInfo(
          dateValue: trend.isNotEmpty ? trend.last : null,
          title: 'TO',
        ),
      ],
    );
  }
}
