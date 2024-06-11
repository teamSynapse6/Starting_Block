import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/model_manage.dart';

class QuestionContactComment extends StatelessWidget {
  final ContactAnswer? contactAnswer;

  const QuestionContactComment({
    super.key,
    required this.contactAnswer,
  });

  String formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    String formattedDate =
        "${dateTime.year}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.day.toString().padLeft(2, '0')}";
    return formattedDate;
  }

  @override
  Widget build(BuildContext context) {
    if (contactAnswer == null) {
      return Container(); // contactAnswer가 null일 경우 빈 Container 반환
    } else {
      String formattedDate = formatDate(contactAnswer!.createdAt);

      return Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '문의처 답장이 있어요',
              style: AppTextStyles.bd5.copyWith(color: AppColors.g5),
            ),
            Gaps.v16,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.bluedark,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.g2,
                      width: 1,
                    ),
                  ),
                  child: AppIcon.contact_logo,
                ),
                Gaps.h10,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        // contactAnswer!.organizationManager,
                        '문의처',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bd3.copyWith(color: AppColors.g6),
                      ),
                      Gaps.v4,
                      Text(
                        contactAnswer!.content,
                        style: AppTextStyles.bd2.copyWith(color: AppColors.g6),
                      ),
                      Gaps.v4,
                      Text(
                        formattedDate,
                        style: AppTextStyles.bd6.copyWith(color: AppColors.g4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Gaps.v20,
            const CustomDividerH2G1(),
          ],
        ),
      );
    }
  }
}
