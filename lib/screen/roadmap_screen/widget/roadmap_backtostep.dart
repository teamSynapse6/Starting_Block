import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class GoBackToStep extends StatefulWidget {
  const GoBackToStep({
    super.key,
  });

  @override
  State<GoBackToStep> createState() => _GoBackToStepState();
}

class _GoBackToStepState extends State<GoBackToStep> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: null,
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
