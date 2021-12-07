import 'package:flutter/material.dart';

class TextFieldDatePicker extends StatelessWidget {
  final TextEditingController controller;
  final Function(DateTime date) onPressed;
  final DateTime? initialDate;
  const TextFieldDatePicker(
      {Key? key,
      required this.controller,
      required this.onPressed,
      this.initialDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (initialDate != null) {
      controller.text =
          '${initialDate!.day}/${initialDate!.month}/${initialDate!.year}';
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Row(
        children: [
          Container(
            decoration:
                const BoxDecoration(border: Border(right: BorderSide())),
            child: InkWell(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
              ),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.calendar_today_rounded),
              ),
              onTap: () async {
                var dateRange = await showDatePicker(
                  initialDate: initialDate ?? DateTime.now(),
                  context: context,
                  firstDate: DateTime(2013, 1, 1),
                  lastDate: DateTime.now(),
                );
                if (dateRange == null) {
                  return;
                }
                onPressed(dateRange);
              },
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.datetime,
              decoration:
                  const InputDecoration.collapsed(hintText: 'dd/mm/yyyy'),
            ),
          )),
        ],
      ),
    );
  }
}
