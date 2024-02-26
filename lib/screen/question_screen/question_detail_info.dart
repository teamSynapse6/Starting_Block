import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  // 날짜 포맷 변경 함수
  String _formatDate(String date) {
    // 'yymmdd' 형식의 문자열을 DateTime 객체로 변환
    final DateTime parsedDate = DateTime.parse('20$date');
    // 'yyyy.MM.dd' 형식으로 날짜 포맷
    return DateFormat('yyyy.MM.dd').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    final String formattedDate = _formatDate(thisDate);

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
              Container(
                width: 40,
                height: 40,
                color: AppColors.blue,
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
