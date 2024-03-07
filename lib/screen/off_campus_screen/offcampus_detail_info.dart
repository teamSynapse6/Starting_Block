import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';

String formatDate(String date) {
  // 문자열 길이가 8이 아니면 원래 날짜 문자열을 반환
  if (date.length != 8) {
    return date;
  }

  String year = date.substring(0, 4);
  String month = date.substring(4, 6);
  String day = date.substring(6, 8);

  return '$year-$month-$day';
}

class OffCampusDetailInfo extends StatelessWidget {
  final String organize,
      title,
      content,
      startDate,
      endDate,
      target,
      type,
      link,
      thisID,
      classification,
      questionCount;

  const OffCampusDetailInfo({
    super.key,
    required this.organize,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.target,
    required this.type,
    required this.link,
    required this.thisID,
    required this.classification,
    required this.content,
    required this.questionCount,
  });

  @override
  Widget build(BuildContext context) {
    String formattedStartDate = formatDate(startDate);
    String formattedEndDate = formatDate(endDate);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gaps.v16,
          Row(
            children: [
              OrganizeChip(text: organize),
              const Spacer(),
            ],
          ),
          Gaps.v16,
          Text(
            title,
            style: AppTextStyles.st1.copyWith(color: AppColors.black),
          ),
          Gaps.v8,
          Text(
            '등록일 $formattedStartDate',
            style: AppTextStyles.bd4.copyWith(color: AppColors.g4),
          ),
          Text(
            '마감일 $formattedEndDate',
            style: AppTextStyles.bd4.copyWith(color: AppColors.g4),
          ),
          Gaps.v12,
          const CustomDivider(),
          Gaps.v16,
          Text('지원 대상', style: AppTextStyles.bd5.copyWith(color: AppColors.g4)),
          Gaps.v4,
          Text(target, style: AppTextStyles.bd2.copyWith(color: AppColors.g6)),
          Gaps.v20,
          Text('지원 유형', style: AppTextStyles.bd5.copyWith(color: AppColors.g4)),
          Gaps.v4,
          Text(type, style: AppTextStyles.bd2.copyWith(color: AppColors.g6)),
          Gaps.v20,
          Text('지원 혜택', style: AppTextStyles.bd5.copyWith(color: AppColors.g4)),
          Gaps.v4,
          Text(content, style: AppTextStyles.bd2.copyWith(color: AppColors.g6)),
          Gaps.v40,
          Row(
            children: [
              DeatailContainButton(
                filledcolor: AppColors.white,
                text: '질문하기 $questionCount',
                textcolor: AppColors.blue,
                onTapAction: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuestionHome(
                        thisID: thisID,
                      ),
                    ),
                  );
                },
              ),
              Gaps.h8,
              DeatailContainButton(
                filledcolor: AppColors.blue,
                text: '자세히 보기',
                textcolor: AppColors.white,
                onTapAction: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewScreen(
                        url: link,
                        id: thisID,
                        classification: '교외사업',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          Gaps.v36,
        ],
      ),
    );
  }
}
