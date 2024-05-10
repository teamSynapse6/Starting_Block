// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class InputChipsDelete extends StatelessWidget {
  final thisIcon, deleteTap, chipTap;
  final String text;

  const InputChipsDelete({
    super.key,
    required this.thisIcon,
    required this.text,
    required this.deleteTap,
    required this.chipTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: chipTap,
      child: Container(
        height: 32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(46),
          border: Border.all(color: AppColors.g3, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gaps.h12,
            Text(
              text,
              style: AppTextStyles.btn1.copyWith(
                color: AppColors.g5,
              ),
            ),
            Gaps.h4,
            GestureDetector(
              onTap: deleteTap,
              child: AppIcon.close,
            ),
            Gaps.h8,
          ],
        ),
      ),
    );
  }
}

class InputChips extends StatelessWidget {
  final String text;
  final VoidCallback? chipTap; // 타입을 명확하게 VoidCallback으로 변경

  const InputChips({
    super.key,
    required this.text,
    this.chipTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // Material의 기본 배경색을 투명하게 설정
      child: Ink(
        height: 32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.white,
          border: Border.all(color: AppColors.g2, width: 1),
        ),
        child: InkWell(
          onTap: chipTap,
          borderRadius: BorderRadius.circular(16), // InkWell의 borderRadius도 설정
          highlightColor: AppColors.g2, // 탭하고 있는 동안의 색상 설정
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 12), // Gaps.h12를 Padding으로 변경
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: AppTextStyles.bd4.copyWith(
                    color: AppColors.g5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DefaultInputChip extends StatelessWidget {
  final String text;
  final chipTap;
  final bool isSelected;

  const DefaultInputChip({
    super.key,
    required this.text,
    this.chipTap,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: chipTap,
      child: Ink(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.blue : AppColors.g1,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              text,
              style: AppTextStyles.btn1.copyWith(
                color: isSelected ? AppColors.white : AppColors.g5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InputChipsCustom extends StatelessWidget {
  final String text;
  final chipTap, thisIcon, thisFilledColor, thisBorderColor, thisTextColor;

  const InputChipsCustom({
    super.key,
    required this.text,
    required this.thisIcon,
    this.chipTap,
    required this.thisFilledColor,
    required this.thisBorderColor,
    required this.thisTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      decoration: BoxDecoration(
        color: thisFilledColor,
        borderRadius: BorderRadius.circular(46),
        border: Border.all(color: thisBorderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Gaps.h12,
          Text(
            text,
            style: AppTextStyles.btn2.copyWith(
              color: thisTextColor,
            ),
          ),
          Gaps.h4,
          Image(image: thisIcon),
          Gaps.h8,
        ],
      ),
    );
  }
}
