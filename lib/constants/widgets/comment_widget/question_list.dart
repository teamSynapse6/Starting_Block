// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class QuestionList extends StatelessWidget {
  final String thisQuestion;
  final int thisLike, thisAnswerCount;
  final bool thisContactAnswer, isMine;
  final thisOnTap;

  const QuestionList({
    super.key,
    required this.thisQuestion,
    required this.thisLike,
    required this.thisAnswerCount,
    required this.thisContactAnswer,
    required this.thisOnTap,
    required this.isMine,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: thisOnTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppIcon.question,
          Gaps.h8,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  thisQuestion,
                  style: AppTextStyles.bd3.copyWith(color: AppColors.g6),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Gaps.v6,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CuriousVote26(
                      isMine: isMine,
                      heartCount: thisLike,
                    ),
                    const Spacer(),
                    thisContactAnswer
                        ? Text(
                            '담당처 답변 보러가기',
                            style: AppTextStyles.bd4
                                .copyWith(color: AppColors.blue),
                          )
                        : Text(
                            '답변 $thisAnswerCount개 보러가기',
                            style: AppTextStyles.bd6
                                .copyWith(color: AppColors.blue),
                          ),
                    AppIcon.arrow_next_14_blue
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
