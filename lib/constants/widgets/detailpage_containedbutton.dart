// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class DeatailContainButton extends StatelessWidget {
  final filledcolor, text, textcolor, onTapAction;

  const DeatailContainButton({
    super.key,
    required this.filledcolor,
    required this.text,
    required this.textcolor,
    required this.onTapAction,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTapAction,
        child: Container(
          height: 44,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(2)),
              color: filledcolor,
              border: Border.all(
                width: 1,
                color: AppColors.bluedark,
              )),
          child: Center(
            child: Text(
              text!,
              style: AppTextStyles.bd3.copyWith(color: textcolor),
            ),
          ),
        ),
      ),
    );
  }
}
