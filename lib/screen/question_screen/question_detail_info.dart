import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class QuestionDetailInfo extends StatelessWidget {
  final String thisUserName, thisQuestion, thisDate, myNickName;
  final int thisLike, thisQuestionHeardID, thisProfileNumber;
  final bool isMyHeart;
  final VoidCallback thisQuestionLikeTap, thisQuestionLikeCancelTap;

  const QuestionDetailInfo({
    super.key,
    required this.thisUserName,
    required this.thisQuestion,
    required this.thisDate,
    required this.thisLike,
    required this.isMyHeart,
    required this.thisQuestionLikeTap,
    required this.thisQuestionLikeCancelTap,
    required this.thisQuestionHeardID,
    required this.myNickName,
    required this.thisProfileNumber,
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
    bool isMyQuestion = thisUserName == myNickName;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.g1,
                  border: Border.all(
                    width: 0.39,
                    color: AppColors.g2,
                  ),
                ),
                child: ProfileIconWidget(iconIndex: thisProfileNumber),
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
                ],
              ),
              const Spacer(),
              isMyQuestion ? Container() : const ReplyCommentReport(),
            ],
          ),
          Gaps.v16,
          Text(
            thisQuestion,
            style: AppTextStyles.bd2.copyWith(color: AppColors.g6),
          ),
          Gaps.v4,
          CuriousVote36(
            isMine: isMyHeart,
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
