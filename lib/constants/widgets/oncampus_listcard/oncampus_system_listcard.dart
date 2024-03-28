import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class OnCampusSysListCard extends StatelessWidget {
  final String thisTitle, thisId, thisContent, thisTarget;

  const OnCampusSysListCard({
    super.key,
    required this.thisTitle,
    required this.thisId,
    required this.thisContent,
    required this.thisTarget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: AppColors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  thisTitle,
                  style: AppTextStyles.bd1.copyWith(color: AppColors.black),
                ),
                const Spacer(),
                // BookMarkButton(id: thisId, classification: '창업제도'),
              ],
            ),
            Gaps.v8,
            Text(
              '내용',
              style: AppTextStyles.bd5.copyWith(color: AppColors.g4),
            ),
            Gaps.v4,
            Text(
              thisContent,
              style: AppTextStyles.bd2.copyWith(color: AppColors.g6),
            ),
            Gaps.v12,
            Text(
              '지원 대상',
              style: AppTextStyles.bd5.copyWith(color: AppColors.g4),
            ),
            Gaps.v4,
            Text(
              thisTarget,
              style: AppTextStyles.bd2.copyWith(color: AppColors.g6),
            ),
          ],
        ),
      ),
    );
  }
}
