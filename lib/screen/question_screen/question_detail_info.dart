import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class QuestionDetailInfo extends StatelessWidget {
  final String thisUserName, thisQuestion, thisDate;
  final int thisLike, thisQuestionHeardID;
  final bool isMine;
  final VoidCallback thisQuestionLikeTap, thisQuestionLikeCancelTap;

  const QuestionDetailInfo({
    super.key,
    required this.thisUserName,
    required this.thisQuestion,
    required this.thisDate,
    required this.thisLike,
    required this.isMine,
    required this.thisQuestionLikeTap,
    required this.thisQuestionLikeCancelTap,
    required this.thisQuestionHeardID,
  });

  String formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate =
        "${dateTime.year}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.day.toString().padLeft(2, '0')}";
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = formatDate(thisDate);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.g3,
              ),
              Gaps.h12,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    thisUserName,
                    style: AppTextStyles.bd1.copyWith(color: AppColors.black),
                  ),
                  Gaps.v4,
                  Text(
                    formattedDate,
                    style: AppTextStyles.bd6.copyWith(color: AppColors.g4),
                  ),
                  Gaps.v4,
                ],
              ),
            ],
          ),
          Gaps.v16,
          Text(
            thisQuestion,
            style: AppTextStyles.bd2.copyWith(color: AppColors.g6),
          ),
          Gaps.v4,
          CuriousVote36(
            isMine: isMine,
            heartCount: thisLike,
            thisTap: thisQuestionHeardID == 0
                ? thisQuestionLikeTap
                : thisQuestionLikeCancelTap,
          ),
        ],
      ),
    );
  }
}
