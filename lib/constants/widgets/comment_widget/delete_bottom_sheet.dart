import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class AnswerCommentDelete extends StatefulWidget {
  final int thisId;

  const AnswerCommentDelete({
    super.key,
    required this.thisId,
  });

  @override
  State<AnswerCommentDelete> createState() => _AnswerCommentDeleteState();
}

class _AnswerCommentDeleteState extends State<AnswerCommentDelete> {
  void thisDeletAction() {}

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
                        thisTapAction: thisDeletAction,
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
