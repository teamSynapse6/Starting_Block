import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/mypage_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';

class MyProfileMyHeart extends StatefulWidget {
  const MyProfileMyHeart({super.key});

  @override
  State<MyProfileMyHeart> createState() => _MyProfileMyHeartState();
}

class _MyProfileMyHeartState extends State<MyProfileMyHeart> {
  List<MyProfileHearModel> myQuestions = [];

  @override
  void initState() {
    super.initState();
    loadMyHeart();
  }

  void loadMyHeart() async {
    var loadedData = await MyPageApi.getMyHeart();
    setState(() {
      myQuestions = loadedData;
    });
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
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 10,
                    ),
                  MyProfileHeartList(
                    thisOrganization: question.announcementType,
                    thisTitle: question.announcementName,
                    thisQuestion: question.questionContent,
                    thisCommentCount: question.answerCount,
                    thisTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QuestionDetail(
                                questionID: question.questionId)),
                      );
                    },
                  ),
                  if (index < myQuestions.length - 1)
                    Container(
                      color: AppColors.white,
                      width: MediaQuery.of(context).size.width,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: CustomDividerG2(),
                      ),
                    )
                ],
              );
            },
          )
        : Column(
            children: [
              Gaps.v10,
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 360,
                color: AppColors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Gaps.v78,
                    Text(
                      '궁금해요를 누른 게시글이 없어요.\n타 창업자들의 질문을 확인해 볼까요?',
                      style: AppTextStyles.bd4.copyWith(color: AppColors.g4),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
              ),
            ],
          );
  }
}
