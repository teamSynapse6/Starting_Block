// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/screen_manage.dart';

String formatedStartDate(String startDate) {
  // 정규 표현식을 사용하여 날짜 형식 (예: 2024-01-01 00:00:00)인지 확인합니다.
  RegExp startDatePattern = RegExp(r'^\d{4}-\d{2}-\d{2}');

  // 문자열이 정규 표현식 패턴에 매치되는 경우
  if (startDatePattern.hasMatch(startDate)) {
    // '2024-01-02 00:00:00.000000'와 같은 문자열을 '2024-01-02' 형식으로 변환
    return startDate.substring(0, 10);
  } else {
    // 패턴에 매치되지 않는 경우, "날짜 정보 없음" 반환
    return startDate;
  }
}

String formatedEndDate(String endDate) {
  // 정규 표현식을 사용하여 날짜 형식 (예: 2024-01-01 00:00:00)인지 확인합니다.
  RegExp endDatePattern = RegExp(r'^\d{4}-\d{2}-\d{2}');

  // 문자열이 정규 표현식 패턴에 매치되는 경우
  if (endDatePattern.hasMatch(endDate)) {
    // '2024-01-02 00:00:00.000000'와 같은 문자열을 '2024-01-02' 형식으로 변환
    return endDate.substring(0, 10);
  } else {
    // 패턴에 매치되지 않는 경우, "날짜 정보 없음" 반환
    return endDate;
  }
}

class ItemList extends StatelessWidget {
  final String thisID,
      thisOrganize,
      thisTitle,
      thisStartDate,
      thisEndDate,
      thisClassification;
  final bool isSaved, isContactExist, isFileUploaded;

  const ItemList({
    super.key,
    required this.thisID,
    required this.thisOrganize,
    required this.thisTitle,
    required this.thisStartDate,
    required this.thisEndDate,
    required this.thisClassification,
    required this.isSaved,
    required this.isContactExist,
    required this.isFileUploaded,
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
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gaps.v16,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                OrganizeChipForOfca(text: thisOrganize),
                if (isContactExist)
                  const Row(
                    children: [
                      Gaps.h4,
                      ConatactChip(),
                    ],
                  ),
                if (isFileUploaded)
                  const Row(
                    children: [
                      Gaps.h4,
                      AIChip(),
                    ],
                  ),
                const Spacer(),
                BookMarkButton(
                  isSaved: isSaved,
                  thisID: thisID,
                )
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
          ],
        ),
      ),
    );
  }
}

class ItemListForRecommend extends StatelessWidget {
  final String thisID,
      thisOrganize,
      thisTitle,
      thisStartDate,
      thisEndDate,
      thisClassification;
  final bool isSaved, isContactExist, isFileUploaded;

  const ItemListForRecommend({
    super.key,
    required this.thisID,
    required this.thisOrganize,
    required this.thisTitle,
    required this.thisStartDate,
    required this.thisEndDate,
    required this.thisClassification,
    required this.isSaved,
    required this.isContactExist,
    required this.isFileUploaded,
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
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gaps.v16,
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                OrganizeChipForOfca(text: thisOrganize),
                if (isContactExist)
                  const Row(
                    children: [
                      Gaps.h4,
                      ConatactChip(),
                    ],
                  ),
                if (isFileUploaded)
                  const Row(
                    children: [
                      Gaps.h4,
                      AIChip(),
                    ],
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
          ],
        ),
      ),
    );
  }
}
