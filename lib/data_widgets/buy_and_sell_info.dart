import 'package:flutter/material.dart';
import 'package:rising_star_crypto_app/common/date_price_info.dart';
import 'package:rising_star_crypto_app/models/date_value.dart';

class BuyAndSellInfo extends StatelessWidget {
  final DateValueData? buyData;
  final DateValueData? sellData;

  const BuyAndSellInfo({
    Key? key,
    required this.buyData,
    required this.sellData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DateValueInfo(
          dateValue: buyData,
          title: 'BUY',
        ),
        Divider(
          thickness: 2.0,
          color: Colors.grey.shade400,
        ),
        DateValueInfo(
          dateValue: sellData,
          title: 'SELL',
        ),
      ],
    );
  }
}
