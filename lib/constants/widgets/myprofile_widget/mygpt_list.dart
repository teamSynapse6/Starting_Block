import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:starting_block/constants/constants.dart';

class MyProfileGptListWidget extends StatelessWidget {
  final String thisTitle, thisLastContent, thisLastDate;
  final VoidCallback thisTap;

  const MyProfileGptListWidget({
    super.key,
    required this.thisTitle,
    required this.thisLastDate,
    required this.thisLastContent,
    required this.thisTap,
  });

  String _formatDate(String rawDate) {
    DateTime date = DateTime.parse(
        "${rawDate.substring(0, 4)}-${rawDate.substring(4, 6)}-${rawDate.substring(6, 8)} ${rawDate.substring(8, 10)}:${rawDate.substring(10, 12)}");
    DateTime now = DateTime.now();
    DateFormat timeFormat = DateFormat('a h:mm', 'ko_KR'); // '오후 4:54' 형식
    String formattedTime =
        timeFormat.format(date).replaceAll('AM', '오전').replaceAll('PM', '오후');

    if (DateFormat('yyyyMMdd').format(date) ==
        DateFormat('yyyyMMdd').format(now)) {
      return formattedTime;
    } else {
      Duration difference = now.difference(date);
      if (difference.inDays == 1) {
        return '어제';
      } else if (difference.inDays > 1) {
        return '${difference.inDays}일 전';
      }
    }

    return formattedTime; // 다른 경우엔 시간을 표시
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: thisTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    thisTitle,
                    style: AppTextStyles.bd3.copyWith(color: AppColors.g6),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Gaps.h8,
                Text(
                  _formatDate(thisLastDate),
                  style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                    color: AppColors.g4,
                  ),
                )
              ],
            ),
            Gaps.v6,
            Text(
              thisLastContent,
              style: AppTextStyles.bd4.copyWith(color: AppColors.black),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          ],
        ),
      ),
    );
  }
}
