import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class GoBackToStep extends StatefulWidget {
  final VoidCallback onResetToCurrentStage;

  const GoBackToStep({
    Key? key,
    required this.onResetToCurrentStage,
  }) : super(key: key);

  @override
  State<GoBackToStep> createState() => _GoBackToStepState();
}

class _GoBackToStepState extends State<GoBackToStep> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onResetToCurrentStage,
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
