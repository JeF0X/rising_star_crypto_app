import 'package:flutter/material.dart';
import 'package:rising_star_crypto_app/common/constants.dart';
import 'package:rising_star_crypto_app/common/date_value_info.dart';
import 'package:rising_star_crypto_app/models/date_value.dart';

class HighestTradingVolumeInfo extends StatelessWidget {
  final DateValueData data;
  final Currency currency;

  const HighestTradingVolumeInfo(
      {Key? key, required this.data, required this.currency})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DateValueInfo(
      title: 'HIGHEST\nVOLUME',
      dateValue: data.value < 0 ? null : data,
    );
  }
}
