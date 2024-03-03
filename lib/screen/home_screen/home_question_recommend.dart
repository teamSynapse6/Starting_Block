import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class HomeQuestionRecommend extends StatefulWidget {
  const HomeQuestionRecommend({super.key});

  @override
  State<HomeQuestionRecommend> createState() => _HomeQuestionRecommendState();
}

class _HomeQuestionRecommendState extends State<HomeQuestionRecommend> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '답변을 기다리는 질문이 있어요',
              style: AppTextStyles.bd1.copyWith(color: AppColors.black),
            ),
            Gaps.v4,
            Text(
              '답변 제공이 다른 창업자에게 큰 도움이 됩니다',
              style: AppTextStyles.bd4.copyWith(color: AppColors.g6),
            ),
            Gaps.v16,
            const CustomDividerH1G1(),
            const HomeQuestionRecommendList(),
          ],
        ),
      ),
    );
  }
}
