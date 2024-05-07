import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:starting_block/constants/constants.dart';

class HomeQuestionStepExpanded extends StatelessWidget {
  const HomeQuestionStepExpanded({super.key});

  @override
  Widget build(BuildContext context) {
    int itemCount = 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '스타터님의 최신 질문이\n발송 준비중이에요',
          style: AppTextStyles.bd1.copyWith(color: AppColors.black),
        ),
        Gaps.v4,
        Text(
          '매일 오전 9시에 발송 예정이에요',
          style: AppTextStyles.bd6.copyWith(color: AppColors.g5),
        ),
        Gaps.v16,
        const CustomDividerH2G1(),
        const CustomDividerH2G1(),
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: itemCount,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Gaps.v20,
                const HomeQuestionStepExpandedList(
                  questionStage: 1,
                ),
                Gaps.v20,
                if (index < itemCount - 1) const CustomDividerH2G1(),
              ],
            );
          },
        ),
      ],
    );
  }
}
