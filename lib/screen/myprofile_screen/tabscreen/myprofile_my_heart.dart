import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/mypage_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';

class MyProfileMyQuesion extends StatefulWidget {
  const MyProfileMyQuesion({super.key});

  @override
  State<MyProfileMyQuesion> createState() => _MyProfileMyQuesionState();
}

class _MyProfileMyQuesionState extends State<MyProfileMyQuesion> {
  List<MyProfileHearModel> myQuestions = [];

  @override
  void initState() {
    super.initState();
    loadMyQuestions();
  }

  void loadMyQuestions() async {
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
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: CustomDividerG2(),
                    )
                ],
              );
            },
          )
        : Container();
  }
}
