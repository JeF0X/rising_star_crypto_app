import 'package:flutter/material.dart';
import 'package:rising_star_crypto_app/models/date_value.dart';

class DateValueInfo extends StatelessWidget {
  final String title;
  final DateValueData? dateValue;
  const DateValueInfo({
    Key? key,
    required this.title,
    required this.dateValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 28.0),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              dateValue == null
                  ? 'No Data'
                  : '${dateValue!.date.day}.${dateValue!.date.month}.${dateValue!.date.year}',
              style: const TextStyle(
                fontSize: 24.0,
              ),
            ),
            Text(
              dateValue == null
                  ? 'No Data'
                  : dateValue!.value.toStringAsFixed(2),
              style: const TextStyle(fontSize: 24.0),
            ),
          ],
        )
      ],
    );
  }
}
