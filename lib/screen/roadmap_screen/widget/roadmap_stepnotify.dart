import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class RoadMapStepNotify extends StatelessWidget {
  const RoadMapStepNotify({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.g4,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          '도약하고 추천사업 받아보기',
          style: AppTextStyles.btn2.copyWith(color: AppColors.white),
        ),
      ),
    );
  }
}
