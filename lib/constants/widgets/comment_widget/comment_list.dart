import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

String formatDate(String date) {
  DateTime dateTime = DateTime.parse(date);
  String formattedDate =
      "${dateTime.year}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.day.toString().padLeft(2, '0')}";
  return formattedDate;
}

class CommentList extends StatefulWidget {
  final String thisUserName, thisAnswer, thisDate;
  final int thisLike;
  final bool isMyHeart;
  final VoidCallback thisTap;

  const CommentList({
    super.key,
    required this.thisUserName,
    required this.thisAnswer,
    required this.thisDate,
    required this.thisLike,
    required this.isMyHeart,
    required this.thisTap,
  });

  @override
  State<CommentList> createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  @override
  Widget build(BuildContext context) {
    String formattedDate = formatDate(widget.thisDate);

    return Container(
      width: MediaQuery.of(context).size.width,
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.g3,
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
              Ink(
                height: 32,
                width: 66,
                child: InkWell(
                  onTap: widget.thisTap,
                  child: Center(
                    child: Text(
                      '답글쓰기',
                      style: AppTextStyles.bd6.copyWith(color: AppColors.g4),
                    ),
                  ),
                ),
              )
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
                    SizedBox(
                      height: 26,
                      child: Row(
                        children: [
                          SizedBox(
                            height: 18,
                            child: widget.isMyHeart
                                ? AppIcon.like_actived
                                : AppIcon.like_inactived,
                          ),
                          Text(
                            '도움이 됐어요 ${widget.thisLike.toString()}',
                            style: AppTextStyles.btn2
                                .copyWith(color: AppColors.g4),
                          ),
                        ],
                      ),
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
