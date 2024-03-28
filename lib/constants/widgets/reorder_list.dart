// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class ReorderCustomTile extends StatelessWidget {
  final String thisText;
  final TextStyle thisTextStyle;
  final bool? isComlete;
  final thisBGColor;

  const ReorderCustomTile({
    super.key,
    required this.thisText,
    required this.thisTextStyle,
    this.isComlete,
    this.thisBGColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Material(
        elevation: 0,
        color: thisBGColor ?? Colors.white,
        child: SizedBox(
          height: 48,
          child: Row(
            children: [
              Text(
                thisText,
                style: thisTextStyle,
              ),
              const Spacer(),
              if (isComlete == true)
                Container()
              else
                SizedBox(
                  height: 24,
                  width: 24,
                  child: AppIcon.sort_actived,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
