import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/screen_manage.dart';

class OffCampusDetailLlmCard extends StatelessWidget {
  final String thisTitle;
  final String thisID;
  final String threadId;

  const OffCampusDetailLlmCard({
    super.key,
    required this.thisTitle,
    required this.thisID,
    required this.threadId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          color: AppColors.bluebg,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI와의 대화를 통해,\n첨부 파일의 필요한 부분을 빠르게 확인해보세요',
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
                          trackedRoute(
                            builder: (context) => LlmChatScreen(
                              thisTitle: thisTitle,
                              thisID: thisID,
                              threadId: threadId,
                            ),
                          ),
                        );
                      },
                      child: SizedBox(
                        height: 40,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Text(
                            'AI로 공고 분석하기',
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
