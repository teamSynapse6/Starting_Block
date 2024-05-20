// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/question_answer_api_manage.dart';

class HomeQuestionStage3 extends StatefulWidget {
  final String thisTitle, thisContent;
  final int questionId;

  const HomeQuestionStage3({
    super.key,
    required this.thisTitle,
    required this.thisContent,
    required this.questionId,
  });

  @override
  State<HomeQuestionStage3> createState() => _HomeQuestionStage3State();
}

class _HomeQuestionStage3State extends State<HomeQuestionStage3> {
  String contactAnswer = '';

  @override
  void initState() {
    super.initState();
    _loadQuestionDetails(widget.questionId);
  }

  Future<void> _loadQuestionDetails(int questionId) async {
    try {
      final questionDetail =
          await QuestionAnswerApi.getQuestionDetail(widget.questionId);
      setState(() {
        contactAnswer = questionDetail.contactAnswer?.content ?? '데이터 없음';
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    Color topColor = const Color(0xff5E8BFF);
    Color bottomColor = const Color(0xffB1C5F6);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            topColor,
            bottomColor,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const BackTitleAppBarForGptList(
          title: '',
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gaps.v24,
              Text(
                '문의처 답변이\n도착했어요',
                style: AppTextStyles.st1.copyWith(color: AppColors.white),
              ),
              Gaps.v49,
              Container(
                color: AppColors.white,
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 14,
                          width: 2,
                          color: AppColors.g4,
                        ),
                        Gaps.h8,
                        Expanded(
                          child: Text(
                            widget.thisTitle,
                            style:
                                AppTextStyles.bd3.copyWith(color: AppColors.g6),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    Gaps.v8,
                    Text(
                      widget.thisContent,
                      style: AppTextStyles.bd4.copyWith(color: AppColors.g5),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppIcon.tail_down_right_24,
                  Gaps.h30,
                ],
              ),
              Gaps.v24,
              Container(
                color: AppColors.white,
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Text(
                  contactAnswer,
                  style: AppTextStyles.bd1.copyWith(color: AppColors.g6),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Gaps.h30,
                  AppIcon.tail_down_left_24,
                ],
              ),
              Gaps.v4,
              Container(
                padding: const EdgeInsets.all(16),
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.bluedark,
                ),
                child: AppIcon.contact_logo,
              )
            ],
          ),
        ),
      ),
    );
  }
}
