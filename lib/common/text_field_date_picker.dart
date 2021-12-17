import 'package:flutter/material.dart';

import 'app_colors.dart';

class TextFieldDatePicker extends StatefulWidget {
  final Function(DateTime date) onPressed;
  final DateTime? initialDate;
  final DateTime lastDate;
  const TextFieldDatePicker(
      {Key? key,
      required this.onPressed,
      this.initialDate,
      required this.lastDate})
      : super(key: key);

  @override
  State<TextFieldDatePicker> createState() => _TextFieldDatePickerState();
}

class _TextFieldDatePickerState extends State<TextFieldDatePicker> {
  DateTime? date;
  var dateText = 'Pick a date';
  Color color = AppColors.select;
  @override
  Widget build(BuildContext context) {
    if (widget.initialDate != null) {
      dateText =
          '${widget.initialDate!.day}/${widget.initialDate!.month}/${widget.initialDate!.year}';
      color = AppColors.select;
    } else {
      color = Colors.red.shade900;
    }

    return Container(
      constraints: const BoxConstraints(minWidth: 110.0, maxWidth: 150.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
        onTap: () async {
          var date = await showDatePicker(
            initialDate: widget.initialDate ??
                DateTime.now().subtract(const Duration(days: 1)),
            context: context,
            firstDate: DateTime(2013, 1, 1),
            lastDate: widget.lastDate,
          );
          if (date == null) {
            return;
          } else {
            var utcDate = DateTime.utc(date.year, date.month, date.day);
            setState(() {
              dateText = '${utcDate.day}/${utcDate.month}/${utcDate.year}';
            });

            widget.onPressed(utcDate);
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
              child: Icon(Icons.calendar_today_rounded),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, top: 8.0, bottom: 8.0, right: 8.0),
              child: Text(
                dateText,
                style: const TextStyle(fontSize: 14.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
