import 'package:flutter/material.dart';
import 'package:rising_star_crypto_app/models/date_value.dart';

class DateValueInfo extends StatelessWidget {
  final String title;
  final DateValueData? dateValue;
  final String valueSymbol;
  const DateValueInfo({
    Key? key,
    this.title = '',
    required this.dateValue,
    this.valueSymbol = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              dateValue == null
                  ? 'No Data'
                  : '${dateValue!.date.day}.${dateValue!.date.month}.${dateValue!.date.year}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            Text(
              dateValue == null
                  ? 'No Data'
                  : '${dateValue!.value.toStringAsFixed(2)} $valueSymbol'
                      .trimRight(),
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ],
        )
      ],
    );
  }
}
