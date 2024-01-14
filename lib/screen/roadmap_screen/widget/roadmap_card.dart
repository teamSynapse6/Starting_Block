import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class RoadMapCard extends StatelessWidget {
  const RoadMapCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 198,
      width: 314,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '창업실습',
                  style: AppTextStyles.bd1.copyWith(color: AppColors.g6),
                ),
                const Spacer(),
                Image(image: AppImages.bookmark_inactived)
              ],
            ),
            Gaps.v10,
            const CustomDividerG2(),
            Gaps.v10,
            Text(
              '내용',
              style: AppTextStyles.bd5.copyWith(color: AppColors.g4),
            ),
            Gaps.v4,
            Text(
              '창업 준비활동(창업실습)을 통해 학습 목표 달성이 원활하게',
              style: AppTextStyles.bd4.copyWith(color: AppColors.g6),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Gaps.v10,
            Text(
              '지원 대상',
              style: AppTextStyles.bd5.copyWith(color: AppColors.g4),
            ),
            Gaps.v4,
            Text(
              '서울대학교 대학원생 및 학부생',
              style: AppTextStyles.bd4.copyWith(color: AppColors.g6),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Gaps.v16,
            Row(
              children: [
                const Spacer(),
                Text(
                  '상세 내용 확인하기',
                  style: AppTextStyles.btn2.copyWith(color: AppColors.g4),
                ),
                Gaps.h14,
                Image(image: AppImages.next_g2_small)
              ],
            )
          ],
        ),
      ),
    );
  }
}
