import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/api/question_answer_api_manage.dart';
import 'package:starting_block/screen/manage/model_manage.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';

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
  List<QuestionModel> _questionData = [];

  @override
  void initState() {
    super.initState();
    loadQuestionData();
  }

  Future<void> loadQuestionData() async {
    List<QuestionModel> questionData =
        await QuestionAnswerApi.getQuestionData(widget.thisID);
    setState(() {
      _questionData = questionData;
    });
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
              builder: (context) => const QuestionWrite(),
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
            Expanded(
              child: ListView.builder(
                  itemCount: _questionData.length,
                  itemBuilder: (context, index) {
                    final item = _questionData[index];
                    return QuestionList(
                      thisQuestion: item.question,
                      thisLike: item.like,
                      thisAnswerCount: item.answerCount,
                      thisContactAnswer: item.contactAnswer,
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
