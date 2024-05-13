import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class OnCaListSystem extends StatelessWidget {
  final String thisTitle, thisId, thisContent, thisTarget;
  final bool isSaved;

  const OnCaListSystem({
    super.key,
    required this.thisTitle,
    required this.thisId,
    required this.thisContent,
    required this.thisTarget,
    required this.isSaved,
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
                BookMarkButton(
                  isSaved: isSaved,
                  thisID: thisId,
                )
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '더보기',
                  style: AppTextStyles.btn2.copyWith(color: AppColors.g4),
                ),
                Gaps.h4,
                AppIcon.arrow_down_16,
              ],
            ),
          ],
        ),
      ),
    );
  }
}
