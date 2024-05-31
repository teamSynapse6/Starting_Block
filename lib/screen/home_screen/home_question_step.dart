// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/home_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';

class HomeQuestionStep extends StatefulWidget {
  final String thisUserName;

  const HomeQuestionStep({
    super.key,
    required this.thisUserName,
  });

  @override
  State<HomeQuestionStep> createState() => _HomeQuestionStepState();
}

class _HomeQuestionStepState extends State<HomeQuestionStep> {
  bool isExpanded = false;
  List<HomeQuestionStatusModel> questionStatus = [];
  bool _isLoading = true; // 로딩 상태 추가

  @override
  void initState() {
    super.initState();
    loadQuestionStatus();
  }

  void _toggleExpand() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  // 질문 발송 상태 API 호출
  void loadQuestionStatus() async {
    try {
      List<HomeQuestionStatusModel> fetchedStatus =
          await HomeApi.getHomeQuestionStatus();
      setState(() {
        questionStatus = fetchedStatus;
        _isLoading = false; // 데이터 로딩 완료
      });
    } catch (e) {
      print('Error fetching question status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || questionStatus.isEmpty) {
      return Container();
    }

    // 마지막 항목이 있는지 확인하고 가져오기
    final lastQuestionStatus =
        questionStatus.isNotEmpty ? questionStatus.last : null;

    List<Map<String, dynamic>> questionStage = [
      {
        "stage": 1,
        "title": "${widget.thisUserName}님의 최신 질문이\n발송 준비중이에요",
        "content": "매일 오전 9시에 발송 예정이에요",
      },
      {
        "stage": 2,
        "title": "담당처에서 답변을\n준비 중이에요",
        "content": "질문에 따라 소요시간이 다를 수 있습니다",
      },
      {
        "stage": 3,
        "title": "${widget.thisUserName}님 질문의\n답변이 도착했어요",
        "content": "추가 궁금한 사항이 있으면, 다시 질문할 수 있어요",
      },
    ];

    // 현재 단계에 해당하는 데이터 찾기
    Map<String, dynamic> currentStage = questionStage.firstWhere(
      (stageData) => stageData["stage"] == lastQuestionStatus!.questionStage,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(4),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isExpanded
                    ? HomeQuestionStepExpanded(
                        thisUserName: widget.thisUserName,
                        questionStatus: questionStatus,
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentStage["title"], // 동적으로 title 반영
                            style: AppTextStyles.bd1
                                .copyWith(color: AppColors.black),
                          ),
                          Gaps.v4,
                          Text(
                            currentStage["content"], // 동적으로 content 반영
                            style:
                                AppTextStyles.bd6.copyWith(color: AppColors.g5),
                          ),
                          Gaps.v16,
                          QuestionStepper(
                            stage: lastQuestionStatus!.questionStage,
                            receptionTime:
                                lastQuestionStatus.formattedReceptionTime,
                            sendTime: lastQuestionStatus.formattedSendTime,
                            arriveTime: lastQuestionStatus.formattedArriveTime,
                          ),
                          Gaps.v16,
                        ],
                      ),
                const CustomDividerH1G1(),
                Gaps.v8,
                SizedBox(
                  child: GestureDetector(
                    onTap: _toggleExpand,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('질문 상세보기',
                            style: AppTextStyles.bd6
                                .copyWith(color: AppColors.g5)),
                        Gaps.h4,
                        isExpanded ? AppIcon.arrow_up_18 : AppIcon.arrow_down_18
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Gaps.v28,
      ],
    );
  }
}
