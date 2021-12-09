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
  @override
  Widget build(BuildContext context) {
    if (widget.initialDate != null) {
      text =
          '${widget.initialDate!.day}/${widget.initialDate!.month}/${widget.initialDate!.year}';
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(15.0),
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
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.calendar_today_rounded),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(text),
            )),
          ],
        ),
      ),
    );
  }
}
