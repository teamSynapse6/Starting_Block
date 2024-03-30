import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';

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
  final List<QuestionModel> _questionData = [];
  final TextEditingController _controller = TextEditingController();
  bool _isTyped = false;

  @override
  void initState() {
    super.initState();
    // 위젯이 초기화될 때 질문 데이터를 가져옵니다.

    _controller.addListener(() {
      if (_controller.text.isNotEmpty && !_isTyped) {
        // TextField에 값이 있고, _isTyped가 false인 경우
        setState(() {
          _isTyped = true; // _isTyped를 true로 설정합니다.
        });
      } else if (_controller.text.isEmpty && _isTyped) {
        // TextField가 비어있고, _isTyped가 true인 경우
        setState(() {
          _isTyped = false; // _isTyped를 false로 설정합니다.
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // 리소스를 정리합니다.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: const BackAppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            const QuestionUserComment(),
          ],
        ),
        bottomNavigationBar: Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: BottomAppBar(
            height: 52,
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
                      child: TextField(
                        controller: _controller,
                        cursorColor: AppColors.g6,
                        minLines: 1,
                        maxLines: null,
                        style: AppTextStyles.bd2.copyWith(color: AppColors.g6),
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(
                            bottom: 9,
                            top: -9,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Gaps.h8,
                  _isTyped ? AppIcon.send_actived : AppIcon.send_inactived,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
