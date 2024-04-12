import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/qestion_answer_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';
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
  List<QuestionListModel> _questionData = [];

  @override
  void initState() {
    super.initState();
    loadQuestionData();
  }

  void loadQuestionData() async {
    final questions = await QuestionAnswerApi.getQuestionList(
        int.tryParse(widget.thisID) ?? 0);
    setState(() {
      _questionData = questions; // _questionData 업데이트
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BackTitleAppBar(
        state: true,
        text: "작성하기",
        thisTextStyle: AppTextStyles.btn1.copyWith(color: AppColors.g5),
        thisOnTap: () async {
          final dynamic result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuestionWrite(
                thisID: widget.thisID,
              ),
            ),
          );
          if (result == true) {
            loadQuestionData();
          }
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
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 32),
                            child: QuestionList(
                              thisQuestion: item.content,
                              thisLike: item.heartCount,
                              thisAnswerCount: item.answerCount,
                              thisContactAnswer: false,
                              isMine: item.isMyHeart,
                              thisOnTap: () async {
                                final dynamic result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => QuestionDetail(
                                      questionID: item.questionId,
                                    ),
                                  ),
                                );
                                if (result == true) {
                                  loadQuestionData();
                                }
                              },
                            ),
                          );
                        }),
                  )
                : Expanded(
                    child: Center(
                      child: Text(
                        '등록된 질문이 없습니다',
                        style: AppTextStyles.bd4.copyWith(
                          color: AppColors.g6,
                        ),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
