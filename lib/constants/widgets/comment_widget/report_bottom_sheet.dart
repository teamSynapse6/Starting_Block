import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class AnswerCommentReport extends StatelessWidget {
  const AnswerCommentReport({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    void thisReportAction() async {
      // 스낵바로 '신고가 접수되었습니다' 메시지 출력

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          content: Text('신고가 접수되었습니다',
              style: AppTextStyles.bd4.copyWith(
                color: AppColors.white,
              )),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xff121212).withOpacity(0.8),
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

class ReplyCommentReport extends StatelessWidget {
  const ReplyCommentReport({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    void thisReportAction() async {
      // 스낵바로 '신고가 접수되었습니다' 메시지 출력

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          content: Text('신고가 접수되었습니다',
              style: AppTextStyles.bd4.copyWith(
                color: AppColors.white,
              )),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: const Color(0xff121212).withOpacity(0.8),
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
      radius: 5,
      onTap: () => reportTap(context),
      child: Container(
        child: AppIcon.more,
      ),
    );
  }
}
