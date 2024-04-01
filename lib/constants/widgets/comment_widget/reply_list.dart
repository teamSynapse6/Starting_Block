import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class ReplyList extends StatelessWidget {
  final String thisUserName, thisDate, thisAnswer;
  final int thisLike;
  final bool isMyHeart;

  const ReplyList({
    super.key,
    required this.thisUserName,
    required this.thisDate,
    required this.thisAnswer,
    required this.thisLike,
    required this.isMyHeart,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDate = formatDate(thisDate);

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Row(
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
                thisUserName,
                style: AppTextStyles.bd5.copyWith(color: AppColors.g6),
              ),
              Text(
                formattedDate,
                style: AppTextStyles.bd6.copyWith(color: AppColors.g4),
              ),
              Gaps.v4,
              Text(
                thisAnswer,
                style: AppTextStyles.bd2.copyWith(color: AppColors.g6),
              ),
              Gaps.v4,
              Ink(
                height: 26,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    isMyHeart
                        ? AppIcon.vote_active_18
                        : AppIcon.vote_inactive_18,
                    Gaps.h2,
                    Text(
                      '도움',
                      style: isMyHeart
                          ? AppTextStyles.btn2.copyWith(color: AppColors.blue)
                          : AppTextStyles.btn2.copyWith(color: AppColors.g4),
                    ),
                    Gaps.h2,
                    Text(
                      thisLike.toString(),
                      style: isMyHeart
                          ? AppTextStyles.btn2.copyWith(color: AppColors.blue)
                          : AppTextStyles.btn2.copyWith(color: AppColors.g4),
                    ),
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
