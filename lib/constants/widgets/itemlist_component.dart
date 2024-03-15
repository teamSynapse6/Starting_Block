// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';

String formatedStartDate(String date) {
  // '20240102'와 같은 문자열을 '2024-01-02' 형식으로 변환
  String startDate = date.substring(0, 10);
  return startDate;
}

String formatedEndDate(String date) {
  // 정규 표현식을 사용하여 날짜 형식 (예: 2024-01-01 00:00:00)인지 확인합니다.
  RegExp datePattern = RegExp(r'^\d{4}-\d{2}-\d{2}');

  // 문자열이 정규 표현식 패턴에 매치되는 경우
  if (datePattern.hasMatch(date)) {
    // '2024-01-02 00:00:00.000000'와 같은 문자열을 '2024-01-02' 형식으로 변환
    return date.substring(0, 10);
  } else {
    // 패턴에 매치되지 않는 경우, 원본 문자열을 그대로 반환
    return date;
  }
}

class ItemList extends StatelessWidget {
  final String thisID,
      thisOrganize,
      thisTitle,
      thisStartDate,
      thisEndDate,
      thisClassification;
  final bool isSaved;

  const ItemList({
    super.key,
    required this.thisID,
    required this.thisOrganize,
    required this.thisTitle,
    required this.thisStartDate,
    required this.thisEndDate,
    required this.thisClassification,
    required this.isSaved,
  });

  @override
  Widget build(BuildContext context) {
    String formattedStartDate = formatedStartDate(thisStartDate);
    String formattedEndDate = formatedEndDate(thisEndDate);

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
                // BookMarkButton(isSaved: ,

                // ),
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
