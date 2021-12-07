import 'package:flutter/material.dart';

class DatePriceInfo extends StatelessWidget {
  final String title;
  final DateTime date;
  final double price;
  const DatePriceInfo(
      {Key? key, required this.title, required this.date, required this.price})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 32.0),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${date.day}.${date.month}.${date.year}',
              style: const TextStyle(
                fontSize: 24.0,
              ),
            ),
            Text(
              '\$$price',
              style: const TextStyle(fontSize: 24.0),
            ),
          ],
        )
      ],
    );
  }
}
