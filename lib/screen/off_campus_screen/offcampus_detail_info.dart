import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/screen_manage.dart';

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
  final VoidCallback thisLoadAction;

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
    required this.thisLoadAction,
  });

  @override
  Widget build(BuildContext context) {
    String formattedStartDate = formatedStartDate(startDate);
    String formattedEndDate = formatedEndDate(endDate);

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
                onTapAction: () async {
                  final dynamic result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => QuestionHome(
                        thisID: thisID,
                      ),
                    ),
                  );
                  if (result == true) {
                    thisLoadAction();
                  }
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
