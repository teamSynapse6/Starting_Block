import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/question_answer_api_manage.dart';

class AnswerCommentDelete extends StatefulWidget {
  final int thisId;
  final VoidCallback thisDeleteAction;

  const AnswerCommentDelete({
    super.key,
    required this.thisId,
    required this.thisDeleteAction,
  });

  @override
  State<AnswerCommentDelete> createState() => _AnswerCommentDeleteState();
}

class _AnswerCommentDeleteState extends State<AnswerCommentDelete> {
  // 답변 삭제를 실행하는 메소드
  void thisDeleteAction() async {
    await QuestionAnswerApi.deleteAnswer(widget.thisId);
    if (mounted) {
      widget.thisDeleteAction();
      Navigator.of(context).pop();
    }
  }

  void deleteTap(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 120,
          child: Column(
            children: [
              Expanded(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width, // 화면 너비만큼 설정
                  child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 48, // 높이를 48로 설정
                      child: BottomSheetList(
                        thisText: '삭제하기',
                        thisColor: AppColors.white,
                        thisTapAction: thisDeleteAction,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => deleteTap(context),
      child: Container(
        child: AppIcon.more,
      ),
    );
  }
}

class ReplyCommentDelete extends StatefulWidget {
  final int thisId;
  final VoidCallback thisDeleteAction;

  const ReplyCommentDelete({
    super.key,
    required this.thisId,
    required this.thisDeleteAction,
  });

  @override
  State<ReplyCommentDelete> createState() => _ReplyCommentDeleteState();
}

class _ReplyCommentDeleteState extends State<ReplyCommentDelete> {
  // 답변 삭제를 실행하는 메소드
  void thisDeleteAction() async {
    await QuestionAnswerApi.deleteReply(widget.thisId);
    if (mounted) {
      widget.thisDeleteAction();
      Navigator.of(context).pop();
    }
  }

  void deleteTap(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 120,
          child: Column(
            children: [
              Expanded(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width, // 화면 너비만큼 설정
                  child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      height: 48, // 높이를 48로 설정
                      child: BottomSheetList(
                        thisText: '삭제하기',
                        thisColor: AppColors.white,
                        thisTapAction: thisDeleteAction,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => deleteTap(context),
      child: Container(
        child: AppIcon.more,
      ),
    );
  }
}
