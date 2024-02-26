import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/api/question_answer_api_manage.dart';
import 'package:starting_block/screen/manage/model_manage.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';

class QuestionDetail extends StatefulWidget {
  final String qid;

  const QuestionDetail({
    super.key,
    required this.qid,
  });

  @override
  State<QuestionDetail> createState() => _QuestionDetailState();
}

class _QuestionDetailState extends State<QuestionDetail> {
  List<QuestionModel> _questionData = [];

  @override
  void initState() {
    super.initState();
    loadQuestionData(); // 위젯이 초기화될 때 질문 데이터를 가져옵니다.
  }

  void loadQuestionData() async {
    final List<QuestionModel> questionData =
        await QuestionAnswerApi.getQuestionDataByQid(widget.qid);
    setState(() {
      _questionData = questionData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(),
      body: Column(
        children: [
          _questionData.isNotEmpty
              ? QuestionDetailInfo(
                  thisUserName: _questionData[0].userName,
                  thisQuestion: _questionData[0].question,
                  thisDate: _questionData[0].date,
                  thisLike: _questionData[0].like,
                )
              : Container(),
          const CustomDividerH8G1(),
        ],
      ),
    );
  }
}
