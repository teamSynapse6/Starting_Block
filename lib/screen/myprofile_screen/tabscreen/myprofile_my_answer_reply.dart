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
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 8,
                      color: AppColors.g1,
                    ),
                  MyAnswerList(
                    thisOrganization: answerReply.announcementType,
                    thisTitle: answerReply.announcementName,
                    questionWriterName: answerReply.questionWriterName,
                    questionContent: answerReply.questionContent,
                    myAnswer: answerReply.myAnswer,
                    myReply: answerReply.myReply,
                  ),
                  if (index < myAnswerReply.length - 1)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: CustomDividerH1G1(),
                    ),
                  if (index == myAnswerReply.length - 1) Gaps.v10,
                ],
              );
            },
          )
        : Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 360,
                color: AppColors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: AppColors.g1,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                    ),
                    Gaps.v78,
                    Text(
                      '작성한 답변이 없어요.\n타 창업자들에게 도움을 제공해 볼까요?',
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
