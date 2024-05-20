import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/home_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';

class HomeQuestionRecommend extends StatefulWidget {
  const HomeQuestionRecommend({super.key});

  @override
  State<HomeQuestionRecommend> createState() => _HomeQuestionRecommendState();
}

class _HomeQuestionRecommendState extends State<HomeQuestionRecommend> {
  List<HomeWaitingQuestionModel> questionList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadWaitingQuestion();
  }

  void loadWaitingQuestion() async {
    try {
      List<HomeWaitingQuestionModel> list = await HomeApi.getWaitingQuestion();
      setState(() {
        questionList = list;
        isLoading = false;
      });
    } catch (e) {}
  }

  void thisOnTap({required int questionID}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuestionDetail(
          questionID: questionID,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const HomeQuestionSkeleton();
    }

    return questionList.isNotEmpty
        ? Material(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(4),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 20,
              ),
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
                    style: AppTextStyles.bd4.copyWith(color: AppColors.g4),
                  ),
                  Gaps.v16,
                  const CustomDividerH1G1(),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: questionList.length,
                    itemBuilder: (context, index) {
                      final item = questionList[index];
                      return Column(
                        children: [
                          Gaps.v16,
                          HomeQuestionRecommendList(
                            thisAnnouncementType: item.announcementType,
                            thisTitle: item.announcementTitle,
                            thisContent: item.questionContent,
                            thisHeartCount: item.heartCount.toString(),
                            thisDate: item.createdAt,
                            thisTap: () =>
                                thisOnTap(questionID: item.questionId),
                          ),
                          if (index < questionList.length - 1) Gaps.v20,
                          if (index < questionList.length - 1)
                            const CustomDividerH1G1(),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          )
        : Container();
  }
}
