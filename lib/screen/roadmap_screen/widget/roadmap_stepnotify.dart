import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class RoadMapStepNotify extends StatelessWidget {
  const RoadMapStepNotify({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            const Spacer(),
            Container(
              height: 44,
              width: 312,
              decoration: const BoxDecoration(color: AppColors.g3),
              child: Center(
                child: Text(
                  '단계 도달 후 추천 지원 사업을 받아보세요',
                  style: AppTextStyles.bd3.copyWith(color: AppColors.white),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
        Gaps.v36,
      ],
    );
  }
}
