import 'package:flutter/material.dart';

class MinimalDropDownButton<T> extends StatelessWidget {
  final T value;
  final List<T> values;
  final Function(T) onChanged;
  final Function(T) menuItemChild;
  const MinimalDropDownButton(
      {Key? key,
      required this.value,
      required this.onChanged,
      required this.values,
      required this.menuItemChild})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton<T>(
      value: value,
      isExpanded: false,
      iconSize: 24,
      elevation: 16,
      isDense: true,
      underline: Container(
        height: 1.0,
        color: Colors.transparent,
      ),
      onChanged: (value) => onChanged(value!),
      items: values.map<DropdownMenuItem<T>>((T value) {
        return DropdownMenuItem<T>(
          value: value,
          child: Text(
            menuItemChild(value),
            style: const TextStyle(fontSize: 18.0),
          ),
        );
      }).toList(),
    );
  }
}
