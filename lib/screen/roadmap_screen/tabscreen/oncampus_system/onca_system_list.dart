import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class OnCaListSystem extends StatelessWidget {
  final String thisTitle, thisId, thisContent, thisTarget;

  const OnCaListSystem({
    super.key,
    required this.thisTitle,
    required this.thisId,
    required this.thisContent,
    required this.thisTarget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  thisTitle,
                  style: AppTextStyles.bd1.copyWith(color: AppColors.g6),
                ),
                const Spacer(),
                // BookMarkButton(id: thisId, classification: '창업제도'),
              ],
            ),
            Gaps.v10,
            const CustomDivider(),
            Gaps.v10,
            Text(
              '지원 대상',
              style: AppTextStyles.bd5.copyWith(color: AppColors.g4),
            ),
            Gaps.v4,
            Text(
              thisTarget,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bd4.copyWith(color: AppColors.g6),
            ),
            Text(
              '내용',
              style: AppTextStyles.bd5.copyWith(color: AppColors.g4),
            ),
            Gaps.v4,
            Text(
              thisContent,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bd4.copyWith(color: AppColors.g6),
            ),
            Gaps.v10,
            Row(
              children: [
                const Spacer(),
                Text(
                  '더보기',
                  style: AppTextStyles.btn2.copyWith(color: AppColors.g4),
                ),
                Gaps.h4,
                AppIcon.next_rightsorted_g4
              ],
            ),
          ],
        ),
      ),
    );
  }
}
