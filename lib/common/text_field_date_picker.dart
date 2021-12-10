import 'package:flutter/material.dart';

class TextFieldDatePicker extends StatefulWidget {
  final Function(DateTime date) onPressed;
  final DateTime? initialDate;
  const TextFieldDatePicker(
      {Key? key, required this.onPressed, this.initialDate})
      : super(key: key);

  @override
  State<TextFieldDatePicker> createState() => _TextFieldDatePickerState();
}

class _TextFieldDatePickerState extends State<TextFieldDatePicker> {
  DateTime? date;
  var text = 'Pick a date';
  Color color = const Color.fromARGB(255, 22, 26, 45);
  @override
  Widget build(BuildContext context) {
    if (widget.initialDate != null) {
      text =
          '${widget.initialDate!.day}/${widget.initialDate!.month}/${widget.initialDate!.year}';
      color = const Color.fromARGB(255, 22, 26, 45);
    } else {
      color = Colors.red.shade900;
    }

    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10.0),
        onTap: () async {
          var date = await showDatePicker(
            initialDate: widget.initialDate ?? DateTime.now(),
            context: context,
            firstDate: DateTime(2013, 1, 1),
            lastDate: DateTime.now(),
          );
          if (date == null) {
            return;
          }
          setState(() {
            text = '${date.day}/${date.month}/${date.year}';
          });

          widget.onPressed(date);
        },
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
              child: Icon(Icons.calendar_today_rounded),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 8.0, top: 8.0, bottom: 8.0, right: 8.0),
              child: Text(
                text,
                style: const TextStyle(fontSize: 16.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
