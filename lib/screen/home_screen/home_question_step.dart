import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';

class HomeQuestionStep extends StatelessWidget {
  final int thisStage;
  final String thisUserName;

  const HomeQuestionStep({
    super.key,
    required this.thisStage,
    required this.thisUserName,
  });

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> questionStage = [
      {
        "stage": 1,
        "title": "$thisUserName님의 질문이\n발송 준비 중이에요",
        "content": "평일 오전 9시에 발송 예정이에요",
      },
      {
        "stage": 2,
        "title": "$thisUserName님의 질문이 발송되었어요",
        "content": "답변이 도착하면 알려드릴게요",
      },
      {
        "stage": 3,
        "title": "$thisUserName님의 질문에 대한\n답변이 도착했어요",
        "content": "도착한 답변을 확인해보세요",
      },
    ];

    // 현재 단계에 해당하는 데이터 찾기
    Map<String, dynamic> currentStage = questionStage.firstWhere(
      (stageData) => stageData["stage"] == thisStage,
      orElse: () => questionStage[0], // 기본값 설정
    );

    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 12),
        child: Column(
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
            QuestionStepper(
              stage: thisStage,
            ),
            Gaps.v20,
            const CustomDividerH1G1(),
            Gaps.v8,
            SizedBox(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('질문 확인',
                        style: AppTextStyles.bd6.copyWith(color: AppColors.g5)),
                    Gaps.h4,
                    AppIcon.arrow_down_18
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
