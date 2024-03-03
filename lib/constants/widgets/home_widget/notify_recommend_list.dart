import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class HomeNotifyRecommendList extends StatelessWidget {
  const HomeNotifyRecommendList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              OfcaOncaChip(isOfca: false),
              Gaps.h8,
              OrganizeChip(text: '송파구청'),
            ],
          ),
          Gaps.v10,
          Text(
            '청년 취창업 멘토링 시범 운영 개시 및 멘티 모집 청년 취창업 멘토링 시범 운영 개시',
            style: AppTextStyles.bd2.copyWith(color: AppColors.g6),
            maxLines: 2,
          ),
          Gaps.v8,
          Text(
            'D-20',
            style: AppTextStyles.bd6.copyWith(color: AppColors.g5),
          )
        ],
      ),
    );
  }
}
