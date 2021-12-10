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
    bool noData = data.length < 2;
    return Column(
      children: [
        DateValueInfo(
          dateValue: noData ? null : data.first,
          title: 'BUY',
          valueSymbol: getCurrencySymbol(currency),
        ),
        Divider(
          thickness: 2.0,
          color: Colors.grey.shade400,
        ),
        DateValueInfo(
          dateValue: noData ? null : data.last,
          title: 'SELL',
          valueSymbol: getCurrencySymbol(currency),
        ),
      ],
    );
  }
}
