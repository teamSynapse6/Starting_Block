import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class GotoSaveRoadmap extends StatelessWidget {
  final VoidCallback tapAction;

  const GotoSaveRoadmap({
    super.key,
    required this.tapAction,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: tapAction,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.g4,
              borderRadius: BorderRadius.circular(2),
            ),
            child: Text(
              '로드맵 설정하러 가기',
              style: AppTextStyles.bd6.copyWith(color: AppColors.white),
            ),
          ),
        )
      ],
    );
  }
}
