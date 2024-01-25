// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class ReorderCustomTile extends StatelessWidget {
  final String thisText;
  final TextStyle thisTextStyle;

  const ReorderCustomTile({
    super.key,
    required this.thisText,
    required this.thisTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Material(
        elevation: 0,
        color: Colors.white,
        child: SizedBox(
          height: 48,
          child: Row(
            children: [
              Text(
                thisText,
                style: thisTextStyle,
              ),
              const Spacer(),
              SizedBox(
                height: 24,
                width: 24,
                child: Image(image: AppImages.sort_actived),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
