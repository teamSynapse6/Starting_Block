// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';

String formatDate(String date) {
  // '20240102'와 같은 문자열을 '2024-01-02' 형식으로 변환
  String year = date.substring(0, 4);
  String month = date.substring(4, 6);
  String day = date.substring(6, 8);

  return '$year-$month-$day';
}

class ItemList extends StatelessWidget {
  final String thisID,
      thisOrganize,
      thisTitle,
      thisStartDate,
      thisEndDate,
      thisClassification;

  const ItemList({
    super.key,
    required this.thisID,
    required this.thisOrganize,
    required this.thisTitle,
    required this.thisStartDate,
    required this.thisEndDate,
    required this.thisClassification,
  });

  @override
  Widget build(BuildContext context) {
    String formattedStartDate = formatDate(thisStartDate);
    String formattedEndDate = formatDate(thisEndDate);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OffCampusDetail(thisID: thisID),
            fullscreenDialog: false,
          ),
        );
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: BorderDirectional(
            bottom: BorderSide(width: 2, color: AppColors.g1),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gaps.v16,
            Row(
              children: [
                OrganizeChip(text: thisOrganize),
                const Spacer(),
                BookMarkButton(
                  id: thisID,
                  classification: thisClassification,
                ),
              ],
            ),
            Gaps.v12,
            Text(
              thisTitle,
              style: AppTextStyles.bd1.copyWith(color: AppColors.g6),
            ),
            Gaps.v10,
            Text(
              '등록일 $formattedStartDate',
              style: AppTextStyles.bd6.copyWith(color: AppColors.g5),
            ),
            Gaps.v4,
            Text(
              '마감일 $formattedEndDate',
              style: AppTextStyles.bd6.copyWith(color: AppColors.g5),
            ),
            Gaps.v16
          ],
        ),
      ),
    );
  }
}
