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
    //마지막 항목이 있는지 확인하고 가져오기
    final lastQuestionStatus =
        questionStatus.isNotEmpty ? questionStatus.last : null;

    if (lastQuestionStatus != null) {
      // 마지막 항목이 존재할 때 처리
    } else {
      // 리스트가 비어 있을 때 처리
    }

    List<Map<String, dynamic>> questionStage = [
      {
        "stage": 1,
        "title": "$thisUserName님의 최신 질문이\n발송 준비중이에요",
        "content": "매일 오전 9시에 발송 예정이에요",
      },
      {
        "stage": 2,
        "title": "담당처에서 답변을\n준비 중이에요",
        "content": "질문에 따라 소요시간이 다를 수 있습니다",
      },
      {
        "stage": 3,
        "title": "$thisUserName님 질문의\n답변이 도착했어요",
        "content": "추가 궁금한 사항이 있으면, 다시 질문할 수 있어요",
      },
    ];

    // 현재 단계에 해당하는 데이터 찾기
    Map<String, dynamic> currentStage = questionStage.firstWhere(
      (stageData) => stageData["stage"] == lastQuestionStatus!.questionStage,
    );

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
          currentStage["title"], // 동적으로 title 반영
          style: AppTextStyles.bd1.copyWith(color: AppColors.black),
        ),
        Gaps.v4,
        Text(
          currentStage["content"], // 동적으로 content 반영
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
            // 인덱스를 반전시켜 역순으로 데이터를 처리
            final reversedIndex = questionStatus.length - 1 - index;
            final thisQuestionStatus = questionStatus[reversedIndex];

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
                if (index < questionStatus.length - 1)
                  const CustomDividerH2G1(),
              ],
            );
          },
        ),
      ],
    );
  }
}
