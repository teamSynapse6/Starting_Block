import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class BottomGradient extends StatelessWidget {
  const BottomGradient({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 14,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.white.withOpacity(0), // 상단 투명도 0
            AppColors.white.withOpacity(0.66), // 50% 지점 투명도 0.66
            AppColors.white.withOpacity(1), // 최하단 투명도 1
          ],
        ),
      ),
    );
  }
}
