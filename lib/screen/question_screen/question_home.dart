import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/screen_manage.dart';

class QuestionHome extends StatefulWidget {
  final String thisID;

  const QuestionHome({
    super.key,
    required this.thisID,
  });

  @override
  State<QuestionHome> createState() => _QuestionHomeState();
}

class _QuestionHomeState extends State<QuestionHome> {
  final List _questionData = []; //변경필요

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackTitleAppBar(
        text: "작성하기",
        thisTextStyle: AppTextStyles.btn1.copyWith(color: AppColors.g5),
        thisOnTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuestionWrite(
                thisID: widget.thisID,
              ),
            ),
          );
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gaps.v20,
            Text(
              '질문 리스트',
              style: AppTextStyles.h5.copyWith(
                color: AppColors.g6,
              ),
            ),
            Gaps.v20,
            _questionData.isNotEmpty
                ? Expanded(
                    child: ListView.builder(
                        itemCount: _questionData.length,
                        itemBuilder: (context, index) {
                          final item = _questionData[index];
                          return QuestionList(
                            thisQuestion: item.question,
                            thisLike: item.like,
                            thisAnswerCount: item.answerCount,
                            thisContactAnswer: item.contactAnswer,
                            thisOnTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        QuestionDetail(qid: item.qid)),
                              );
                            },
                          );
                        }),
                  )
                : Center(
                    child: Text(
                      '등록된 질문이 없습니다',
                      style: AppTextStyles.bd4.copyWith(
                        color: AppColors.g6,
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
