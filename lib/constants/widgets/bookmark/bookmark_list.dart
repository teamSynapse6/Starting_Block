// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class BookMarkList extends StatelessWidget {
  final String thisText;
  final thisColor, thisTapAction, thisIcon;

  const BookMarkList({
    super.key,
    required this.thisText,
    required this.thisColor,
    required this.thisTapAction,
    required this.thisIcon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: thisTapAction,
      child: Container(
        height: 48,
        color: thisColor, // null일 수 있는 색상 적용
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24), // Padding 추가
          child: Row(
            children: [
              Text(
                thisText,
                style: AppTextStyles.bd2.copyWith(color: AppColors.g6),
              ),
              const Spacer(),
              GestureDetector(
                onTap: thisTapAction,
                child: thisIcon,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
