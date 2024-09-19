import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/screen_manage.dart';

class OnCampusNotifyListCard extends StatelessWidget {
  final String thisProgramText, thisId, thisTitle, thisStartDate, thisUrl;

  final bool isSaved;

  const OnCampusNotifyListCard({
    super.key,
    required this.thisProgramText,
    required this.thisId,
    required this.thisTitle,
    required this.thisStartDate,
    required this.thisUrl,
    required this.isSaved,
  });

  String formatedStartDate(String date) {
    // '20240102'와 같은 문자열을 '2024-01-02' 형식으로 변환
    String startDate = date.substring(0, 10);
    return startDate;
  }

  // 매핑 함수 추가
  String mapProgramText(String program) {
    Map<String, String> programMapping = {
      'CLUB': '창업 동아리',
      'CAMP': '창업 캠프',
      'CONTEST': '창업 경진대회',
      'LECTURE': '창업 특강',
      'MENTORING': '멘토링',
      'ETC': '기타',
    };
    return programMapping[program] ?? program; // 매핑 테이블에 없는 경우 원래 값을 반환
  }

  @override
  Widget build(BuildContext context) {
    String formattedStartDate = formatedStartDate(thisStartDate);
    String formattedProgramText = mapProgramText(thisProgramText);

    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OncampusWebViewScreen(
                url: thisUrl,
                id: thisId,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                OrganizeChipForOnca(text: formattedProgramText),
                const Spacer(),
                BookMarkButton(isSaved: isSaved, thisID: thisId)
              ],
            ),
            Gaps.v12,
            Text(
              thisTitle,
              style: AppTextStyles.bd1.copyWith(color: AppColors.g6),
            ),
            Gaps.v8,
            Text(
              '등록일 $formattedStartDate',
              style: AppTextStyles.bd6.copyWith(color: AppColors.g5),
            ),
          ],
        ),
      ),
    );
  }
}
