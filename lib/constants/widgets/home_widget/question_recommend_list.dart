import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class HomeQuestionRecommendList extends StatelessWidget {
  const HomeQuestionRecommendList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 26,
            color: AppColors.g1,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    '교외',
                    style: AppTextStyles.bd6.copyWith(color: AppColors.salmon),
                  ),
                  Gaps.h12,
                  Text(
                    '여기는 공고제목',
                    style: AppTextStyles.bd6.copyWith(color: AppColors.g5),
                  ),
                ],
              ),
            ),
          ),
          Gaps.v12,
          Text(
            '여기는 공고질문영역',
            style: AppTextStyles.bd2.copyWith(color: AppColors.g6),
            maxLines: 2,
          ),
          Gaps.v12,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '저도 궁금해요 3',
                style: AppTextStyles.bd6.copyWith(color: AppColors.g4),
              ),
              Text(
                '2023-11-30',
                style: AppTextStyles.bd6.copyWith(color: AppColors.g4),
              ),
            ],
          )
        ],
      ),
    );
  }
}
