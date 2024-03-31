import 'package:flutter/material.dart';
import 'package:starting_block/constants/color_table.dart';
import 'package:starting_block/constants/font_table.dart';
import 'package:starting_block/constants/gaps.dart';
import 'package:starting_block/constants/icon_table.dart';

class QuestionDetailInfo extends StatelessWidget {
  final String thisUserName, thisQuestion, thisDate;
  final int thisLike;

  const QuestionDetailInfo({
    super.key,
    required this.thisUserName,
    required this.thisQuestion,
    required this.thisDate,
    required this.thisLike,
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
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
        vertical: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 16,
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
          SizedBox(
            height: 32,
            child: Row(
              children: [
                AppIcon.like_inactived,
                Gaps.h4,
                Text(
                  '궁금해요 $thisLike',
                  style: AppTextStyles.btn2.copyWith(color: AppColors.g4),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
