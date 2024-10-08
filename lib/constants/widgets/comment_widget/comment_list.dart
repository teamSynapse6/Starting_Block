import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

String formatDate(String date) {
  DateTime dateTime = DateTime.parse(date);
  String formattedDate =
      "${dateTime.year}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.day.toString().padLeft(2, '0')}";
  return formattedDate;
}

class CommentList extends StatefulWidget {
  final String thisUserName, thisAnswer, thisDate, myNickName;
  final int thisLike, thisAnswerId, thisProfileNumber;
  final bool isMyHeart, isMyAnswer;
  final VoidCallback thisReplyTap,
      thisCommentHeartTap,
      thisCommenHeartDeleteTap,
      thisAnswerDeleteTap;

  const CommentList({
    super.key,
    required this.thisUserName,
    required this.thisAnswer,
    required this.thisDate,
    required this.thisLike,
    required this.isMyHeart,
    required this.thisReplyTap,
    required this.thisAnswerId,
    required this.thisCommentHeartTap,
    required this.thisCommenHeartDeleteTap,
    required this.isMyAnswer,
    required this.thisAnswerDeleteTap,
    required this.myNickName,
    required this.thisProfileNumber,
  });

  @override
  State<CommentList> createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  @override
  Widget build(BuildContext context) {
    String formattedDate = formatDate(widget.thisDate);
    bool isMyComment = widget.thisUserName == widget.myNickName;

    return Container(
      width: MediaQuery.of(context).size.width,
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.g1,
                  border: Border.all(
                    width: 0.39,
                    color: AppColors.g2,
                  ),
                ),
                child: ProfileIconWidget(iconIndex: widget.thisProfileNumber),
              ),
              Gaps.h10,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.thisUserName,
                      style: AppTextStyles.bd3.copyWith(color: AppColors.g6)),
                  Text(formattedDate,
                      style: AppTextStyles.bd6.copyWith(color: AppColors.g4)),
                ],
              ),
              const Spacer(),
              isMyComment
                  ? AnswerCommentDelete(
                      thisId: widget.thisAnswerId,
                      thisDeleteAction: widget.thisAnswerDeleteTap,
                    )
                  : const AnswerCommentReport(),
            ],
          ),
          Gaps.h4,
          Row(
            children: [
              Gaps.h42,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.thisAnswer,
                      style: AppTextStyles.bd2.copyWith(color: AppColors.g6),
                      softWrap: true,
                    ),
                    Gaps.v4,
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Ink(
                          height: 26,
                          child: InkWell(
                            onTap: widget.isMyHeart
                                ? widget.thisCommenHeartDeleteTap
                                : widget.thisCommentHeartTap,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                widget.isMyHeart
                                    ? AppIcon.vote_active_18
                                    : AppIcon.vote_inactive_18,
                                Gaps.h2,
                                Text(
                                  '도움',
                                  style: widget.isMyHeart
                                      ? AppTextStyles.btn2
                                          .copyWith(color: AppColors.blue)
                                      : AppTextStyles.btn2
                                          .copyWith(color: AppColors.g4),
                                ),
                                Gaps.h2,
                                Text(
                                  widget.thisLike.toString(),
                                  style: widget.isMyHeart
                                      ? AppTextStyles.btn2
                                          .copyWith(color: AppColors.blue)
                                      : AppTextStyles.btn2
                                          .copyWith(color: AppColors.g4),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Gaps.h16,
                        Ink(
                          height: 26,
                          child: InkWell(
                            onTap: widget.thisReplyTap,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 18,
                                  child: AppIcon.comments,
                                ),
                                Gaps.h3,
                                Text(
                                  '답글쓰기',
                                  style: AppTextStyles.btn2
                                      .copyWith(color: AppColors.g4),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
