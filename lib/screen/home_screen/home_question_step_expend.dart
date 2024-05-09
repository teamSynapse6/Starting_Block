import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';

class HomeQuestionStepExpanded extends StatelessWidget {
  final String thisUserName;
  final List<HomeQuestionStatusModel> questionStatus;

  const HomeQuestionStepExpanded({
    super.key,
    required this.thisUserName,
    required this.questionStatus,
  });

  @override
  Widget build(BuildContext context) {
    int itemCount = 1;

    void thisQuestionTap({required HomeQuestionStatusModel tapQuestionStatus}) {
      if (tapQuestionStatus.questionStage == 1) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomeQuestionStage1(
                      thisTitle: tapQuestionStatus.title,
                      thisContent: tapQuestionStatus.content,
                    )));
      } else if (tapQuestionStatus.questionStage == 2) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomeQuestionStage2(
                      thisTitle: tapQuestionStatus.title,
                      thisContent: tapQuestionStatus.content,
                      thisSendTime: tapQuestionStatus.formattedSendTime,
                    )));
      } else if (tapQuestionStatus.questionStage == 3) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HomeQuestionStage3(
              thisTitle: tapQuestionStatus.title,
              thisContent: tapQuestionStatus.content,
              questionId: tapQuestionStatus.questionId,
            ),
          ),
        );
      }
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
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: questionStatus.length,
          itemBuilder: (context, index) {
            final thisQuestionStatus = questionStatus[index];

            return Column(
              children: [
                Gaps.v20,
                HomeQuestionStepExpandedList(
                  questionStage: thisQuestionStatus.questionStage,
                  thisTitle: thisQuestionStatus.title,
                  thisQuestion: thisQuestionStatus.content,
                  thisReceptionTime: thisQuestionStatus.formattedReceptionTime,
                  thisSendTime: thisQuestionStatus.formattedSendTime,
                  thisArriveTime: thisQuestionStatus.formattedArriveTime,
                  thisQuestionStage: thisQuestionStatus.questionStage,
                  thisQuestionTap: () => thisQuestionTap(
                    tapQuestionStatus: thisQuestionStatus,
                  ),
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
