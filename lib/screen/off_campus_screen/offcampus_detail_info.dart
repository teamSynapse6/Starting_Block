import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';

class OffCampusDetailBody extends StatelessWidget {
  final String organize;
  final String title;
  final String startDate;
  final String endDate;
  final String age;
  final String type;
  final String link;
  final String thisID;
  final String classification;

  const OffCampusDetailBody({
    Key? key,
    required this.organize,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.age,
    required this.type,
    required this.link,
    required this.thisID,
    required this.classification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            '등록일 $startDate',
            style: AppTextStyles.bd4.copyWith(color: AppColors.g4),
          ),
          Text(
            '마감일 $endDate',
            style: AppTextStyles.bd4.copyWith(color: AppColors.g4),
          ),
          Gaps.v12,
          const CustomDivider(),
          Gaps.v16,
          Text('지원 대상', style: AppTextStyles.bd5.copyWith(color: AppColors.g4)),
          Gaps.v4,
          Text(age, style: AppTextStyles.bd2.copyWith(color: AppColors.g6)),
          Gaps.v20,
          Text('지원 유형', style: AppTextStyles.bd5.copyWith(color: AppColors.g4)),
          Gaps.v4,
          Text(type, style: AppTextStyles.bd2.copyWith(color: AppColors.g6)),
          Gaps.v20,
          Text('지원 혜택', style: AppTextStyles.bd5.copyWith(color: AppColors.g4)),
          Gaps.v4,
          Text('여기는 아직 데이터 없음', //수정필요
              style: AppTextStyles.bd2.copyWith(color: AppColors.g6)),
          Gaps.v40,
          Row(
            children: [
              const DeatailContainButton(
                filledcolor: AppColors.white,
                text: '질문하기 24',
                textcolor: AppColors.bluedark,
                onTapAction: null,
              ),
              Gaps.h8,
              DeatailContainButton(
                filledcolor: AppColors.bluedark,
                text: '자세히 보기',
                textcolor: AppColors.white,
                onTapAction: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WebViewScreen(
                        url: link,
                        id: thisID,
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
