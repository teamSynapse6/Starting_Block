import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class AnswerCommentReport extends StatefulWidget {
  const AnswerCommentReport({super.key});

  @override
  State<AnswerCommentReport> createState() => _AnswerCommentReportState();
}

class _AnswerCommentReportState extends State<AnswerCommentReport> {
  @override
  Widget build(BuildContext context) {
    void thisReportAction() async {
      // 스낵바로 '신고가 접수되었습니다' 메시지 출력
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('신고가 접수되었습니다'),
          duration: Duration(seconds: 2),
          backgroundColor: AppColors.activered,
        ),
      );
    }

    void reportTap(BuildContext context) async {
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
                          thisText: '신고하기',
                          thisColor: AppColors.white,
                          thisTapAction: thisReportAction,
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

    return InkWell(
      onTap: () => reportTap(context),
      child: Container(
        child: AppIcon.more,
      ),
    );
  }
}

class ReplyCommentReport extends StatefulWidget {
  const ReplyCommentReport({super.key});

  @override
  State<ReplyCommentReport> createState() => _ReplyCommentReportState();
}

class _ReplyCommentReportState extends State<ReplyCommentReport> {
  @override
  Widget build(BuildContext context) {
    void thisReportAction() async {
      // 스낵바로 '신고가 접수되었습니다' 메시지 출력
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('신고가 접수되었습니다'),
          duration: Duration(seconds: 2),
          backgroundColor: AppColors.activered,
        ),
      );
    }

    void reportTap(BuildContext context) async {
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
                          thisText: '신고하기',
                          thisColor: AppColors.white,
                          thisTapAction: thisReportAction,
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

    return InkWell(
      onTap: () => reportTap(context),
      child: Container(
        child: AppIcon.more,
      ),
    );
  }
}
