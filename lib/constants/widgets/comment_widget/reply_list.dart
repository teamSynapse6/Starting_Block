import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class ReplyList extends StatefulWidget {
  final String thisUserName, thisDate, thisAnswer;
  final int thisLike, thisReplyId;
  final bool isMyHeart, isMyReply;
  final VoidCallback thisReplyHeartTap,
      thisReplyHeartDeleteTap,
      thisReplyDeleteTap;

  const ReplyList({
    super.key,
    required this.thisUserName,
    required this.thisDate,
    required this.thisAnswer,
    required this.thisLike,
    required this.isMyHeart,
    required this.thisReplyHeartTap,
    required this.thisReplyHeartDeleteTap,
    required this.isMyReply,
    required this.thisReplyId,
    required this.thisReplyDeleteTap,
  });

  @override
  State<ReplyList> createState() => _ReplyListState();
}

class _ReplyListState extends State<ReplyList> {
  @override
  Widget build(BuildContext context) {
    String formattedDate = formatDate(widget.thisDate);

    return Container(
      padding: const EdgeInsets.fromLTRB(66 - 24, 8, 0, 8),
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 12,
                backgroundColor: AppColors.g3,
              ),
              Gaps.h8,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.thisUserName,
                    style: AppTextStyles.bd5.copyWith(color: AppColors.g6),
                  ),
                  Text(
                    formattedDate,
                    style: AppTextStyles.bd6.copyWith(color: AppColors.g4),
                  ),
                ],
              ),
              const Spacer(),
              widget.isMyReply
                  ? ReplyCommentDelete(
                      thisId: widget.thisReplyId,
                      thisDeleteAction: widget.thisReplyDeleteTap)
                  : const ReplyCommentReport(),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gaps.v4,
                Text(
                  widget.thisAnswer,
                  style: AppTextStyles.bd2.copyWith(color: AppColors.g6),
                ),
                Gaps.v4,
                Ink(
                  height: 26,
                  child: InkWell(
                    onTap: widget.isMyHeart
                        ? widget.thisReplyHeartDeleteTap
                        : widget.thisReplyHeartTap,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
