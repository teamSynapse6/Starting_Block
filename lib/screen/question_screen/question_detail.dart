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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
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
        bottomNavigationBar: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: BottomAppBar(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 10,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.5,
                          color: AppColors.g2,
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextFormField(
                        cursorColor: AppColors.g5,
                        cursorHeight: 20,
                        style: AppTextStyles.bd2.copyWith(
                          color: AppColors.g5,
                        ),
                        decoration: const InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          hintText: "Enter your text here",
                        ),
                        minLines: 1,
                        maxLines: null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
