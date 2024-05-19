import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/screen_manage.dart';

class OnCaListNotify extends StatelessWidget {
  final String thisProgramType, thisID, thisTitle, thisUrl, thisStartDate;
  final bool thisIsSaved;

  const OnCaListNotify({
    super.key,
    required this.thisProgramType,
    required this.thisID,
    required this.thisTitle,
    required this.thisUrl,
    required this.thisStartDate,
    required this.thisIsSaved,
  });

  // 날짜 형식 변환 메소드
  String formatDate(String date) {
    if (date.length == 6) {
      return "20${date.substring(0, 2)}-${date.substring(2, 4)}-${date.substring(4, 6)}";
    }
    return date; // 형식에 맞지 않는 경우 원본 반환
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OncampusWebViewScreen(
              url: thisUrl,
              id: thisID,
            ),
          ),
        );
      },
      child: Container(
        width: 312,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  OrganizeChip(
                    text: thisProgramType,
                  ),
                  const Spacer(),
                  BookMarkButton(
                    isSaved: thisIsSaved,
                    thisID: thisID,
                  ),
                ],
              ),
              Gaps.v10,
              Text(
                thisTitle,
                style: AppTextStyles.bd1.copyWith(color: AppColors.g6),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Gaps.v8,
              Text(
                '등록일 ${formatDate(thisStartDate)}',
                style: AppTextStyles.bd6.copyWith(color: AppColors.g5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
