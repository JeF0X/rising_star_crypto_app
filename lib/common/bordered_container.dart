import 'package:flutter/material.dart';

class BorderedContainer extends StatelessWidget {
  final Widget child;
  const BorderedContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white38,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(10.0)),
      child: child,
    );
  }
}
