import 'package:flutter/material.dart';
import 'package:rising_star_crypto_app/common/constants.dart';

class BordelessFlatCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;

  const BordelessFlatCard({
    Key? key,
    required this.title,
    required this.child,
    this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          color: AppColors.select, borderRadius: BorderRadius.circular(15.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 18.0),
                ),
                subtitle == null
                    ? const SizedBox()
                    : Text(
                        subtitle!,
                        style: const TextStyle(fontSize: 10.0),
                      ),
              ],
            ),
          ),
          // Data info
          Stack(
            fit: StackFit.loose,
            alignment: AlignmentDirectional.center,
            children: [
              Container(
                decoration: const BoxDecoration(),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: child,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
