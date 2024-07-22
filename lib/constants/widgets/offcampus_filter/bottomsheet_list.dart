// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class BottomSheetList extends StatelessWidget {
  final String thisText;
  final thisColor, thisTapAction;

  const BottomSheetList({
    super.key,
    required this.thisText,
    required this.thisColor,
    required this.thisTapAction,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: thisTapAction,
        child: Ink(
          height: 48,
          color: thisColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24), // Padding 추가
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                thisText,
                style: AppTextStyles.bd2.copyWith(color: AppColors.g6),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
