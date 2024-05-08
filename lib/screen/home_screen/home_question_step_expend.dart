import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/screen_manage.dart';

class HomeQuestionStepExpanded extends StatelessWidget {
  final String thisUserName;

  const HomeQuestionStepExpanded({
    super.key,
    required this.thisUserName,
  });

  @override
  Widget build(BuildContext context) {
    int itemCount = 1;
    int quetionStage = 3;

    void thisQuestionTap() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeQuestionStepDetail(
            questionStage: quetionStage,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$thisUserName님의 최신 질문이\n발송 준비중이에요',
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
                HomeQuestionStepExpandedList(
                  questionStage: quetionStage,
                  thisQuestionTap: thisQuestionTap,
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
