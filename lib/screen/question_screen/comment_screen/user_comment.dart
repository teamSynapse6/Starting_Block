import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class QuestionUserComment extends StatelessWidget {
  const QuestionUserComment({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gaps.v14,
          Text(
            '타 창업자 도움 [개수]',
            style: AppTextStyles.bd5.copyWith(color: AppColors.g4),
          ),
          Gaps.v24,
        ],
      ),
    );
  }
}
