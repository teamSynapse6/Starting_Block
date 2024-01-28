// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class DeleteList extends StatelessWidget {
  final String thisText;
  final thisTap, thisBackgroundColor;

  const DeleteList({
    super.key,
    required this.thisText,
    required this.thisTap,
    required this.thisBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      color: thisBackgroundColor,
      child: Center(
        child: Row(
          children: [
            Gaps.h24,
            GestureDetector(
              onTap: thisTap,
              child: AppIcon.delete,
            ),
            Gaps.h16,
            Text(
              thisText,
              style: AppTextStyles.bd2.copyWith(color: AppColors.g6),
            )
          ],
        ),
      ),
    );
  }
}
