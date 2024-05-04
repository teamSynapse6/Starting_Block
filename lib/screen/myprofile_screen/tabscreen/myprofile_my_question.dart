import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/mypage_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';

class MyProfileMyQuestion extends StatefulWidget {
  const MyProfileMyQuestion({super.key});

  @override
  State<MyProfileMyQuestion> createState() => _MyProfileMyQuestionState();
}

class _MyProfileMyQuestionState extends State<MyProfileMyQuestion> {
  List<MyProfileQuestion> myQuestions = [];

  @override
  initState() {
    super.initState();
    loadMyQuestion();
  }

  void loadMyQuestion() async {
    var loadedData = await MyPageApi.getMyQuestion();
    setState(() {
      myQuestions = loadedData;
    });
  }

  // void loadMyQuestion() async {
  //   // 임시 데이터 생성
  //   MyProfileQuestion tempQuestion = MyProfileQuestion.fromJson({
  //     "announcementType": "교외",
  //     "announcementName": "청년 취창업 멘토링",
  //     "questionId": 1,
  //     "questionContent": "개별 멘토링 진행 시..",
  //     "createdAt": "2024-04-19T15:35:57.346Z",
  //     "heartCount": 16,
  //     "answerCount": 16,
  //     "organizationManger": "송파구청 일자리정책담당관",
  //     "contactAnswerContent": "답변 드리겠습니다.데이터를 길게게ㅔ게게게ㅔ게ㅔ게게ㅔ게ㅔ게게ㅔ게ㅔ게게메엠네엠네엠넹ㄴㅁ"
  //   });

  //   setState(() {
  //     // 기존 네트워크 호출 대신 임시 데이터를 리스트에 추가
  //     myQuestions = [tempQuestion];
  //   });
  // }

  void _thisTap(int questionID) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuestionDetail(questionID: questionID),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return myQuestions.isNotEmpty
        ? ListView.builder(
            itemCount: myQuestions.length,
            itemBuilder: (context, index) {
              final question = myQuestions[index];
              return Column(
                children: [
                  if (index == 0)
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 8,
                      color: AppColors.g1,
                    ),
                  MyQuestionList(
                    thisOrganization: question.announcementType,
                    thisTitle: question.announcementName,
                    questionContent: question.questionContent,
                    createdAt: question.createdAt,
                    heartCount: question.heartCount,
                    answerCount: question.answerCount,
                    organizationManger: question.organizationManger,
                    contactAnswerContent: question.contactAnswerContent,
                    thisTap: () => _thisTap(question.questionId),
                  ),
                  if (index < myQuestions.length - 1)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: CustomDividerH1G1(),
                    ),
                  if (index == myQuestions.length - 1) Gaps.v10,
                ],
              );
            })
        : Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                color: AppColors.g1,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Gaps.v78,
                  Text(
                    '작성한 질문이 없어요.\n공고를 탐색하며, 궁금한 사항은 질문을 작성해 볼까요?',
                    style: AppTextStyles.bd4.copyWith(color: AppColors.g4),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ],
          );
  }
}
