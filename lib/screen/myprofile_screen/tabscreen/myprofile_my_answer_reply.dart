import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/mypage_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';

class MyProfileMyAnswerReply extends StatefulWidget {
  const MyProfileMyAnswerReply({super.key});

  @override
  State<MyProfileMyAnswerReply> createState() => _MyProfileMyAnswerReplyState();
}

class _MyProfileMyAnswerReplyState extends State<MyProfileMyAnswerReply> {
  List<MyAnswerReplyModel> myAnswerReply = [];

  @override
  void initState() {
    loadMyAnswerReply();
    super.initState();
  }

  void loadMyAnswerReply() async {
    var loadedData = await MyPageApi.getMyAnswerReply();
    setState(() {
      myAnswerReply = loadedData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return myAnswerReply.isNotEmpty
        ? ListView.builder(
            itemCount: myAnswerReply.length,
            itemBuilder: (context, index) {
              final answerReply = myAnswerReply[index];
              return Column(
                children: [
                  if (index == 0)
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 10,
                    ),
                  MyAnswerList(
                    thisOrganization: answerReply.announcementType,
                    thisTitle: answerReply.announcementName,
                    questionWriterName: answerReply.questionWriterName,
                    questionContent: answerReply.questionContent,
                    myAnswer: answerReply.myAnswer,
                    myReply: answerReply.myReply,
                  ),
                  if (index < myAnswerReply.length - 1) Gaps.v4,
                  if (index == myAnswerReply.length - 1) Gaps.v10,
                ],
              );
            },
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Gaps.v78,
              Text(
                '작성한 답변이 없어요.\n타 창업자들에게 도움을 제공해 볼까요?',
                style: AppTextStyles.bd4.copyWith(color: AppColors.g4),
                textAlign: TextAlign.center,
              )
            ],
          );
  }
}
