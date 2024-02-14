import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class OnBoardingState extends StatelessWidget {
  final int thisState;
  const OnBoardingState({super.key, required this.thisState});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(6, (index) {
        return Row(
          children: [
            Icon(
              Icons.circle,
              size: 8.0, // 직접적인 크기 값을 사용합니다. Sizes.size8 대신에
              color: thisState == index + 1 ? AppColors.blue : AppColors.g2,
            ),
            const SizedBox(width: 4.0), // Gaps.h4 대신에, 직접적인 간격 값을 사용합니다.
          ],
        );
      }),
    );
  }
}
