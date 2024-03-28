// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class GoBackToStep extends StatelessWidget {
  final thisTap;

  const GoBackToStep({
    super.key,
    required this.thisTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: thisTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(4),
        ),
        height: 32,
        width: 113,
        child: Center(
          child: Row(
            children: [
              Gaps.h12,
              Text(
                '현 단계로 돌아가기',
                style: AppTextStyles.btn2.copyWith(color: AppColors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
