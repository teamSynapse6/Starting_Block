import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/screen_manage.dart';

class OffCampusDetailGptCard extends StatelessWidget {
  final String thisTitle;
  final String thisID;

  const OffCampusDetailGptCard({
    super.key,
    required this.thisTitle,
    required this.thisID,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Gaps.v4,
        Container(
          width: MediaQuery.of(context).size.width,
          color: AppColors.bluebg,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI와 대화를 통해,\n공고 첨부 파일의 필요한 부분을 빠르게 확인해보세요',
                  style: AppTextStyles.bd4.copyWith(color: AppColors.g6),
                ),
                Gaps.v14,
                Material(
                  color: Colors.transparent,
                  child: Ink(
                    color: AppColors.white,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GptChatScreen(
                                thisTitle: thisTitle, thisID: thisID),
                          ),
                        );
                      },
                      child: SizedBox(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Text(
                            'AI와 대화 시작하기',
                            style: AppTextStyles.bd4
                                .copyWith(color: AppColors.blue),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Gaps.v32,
      ],
    );
  }
}
