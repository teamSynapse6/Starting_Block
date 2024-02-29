import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class OnCampusSetNotify extends StatelessWidget {
  const OnCampusSetNotify({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: AppBar(
            actions: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SizedBox(
                  height: 48,
                  width: 48,
                  child: AppIcon.close24,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gaps.v40,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '나만의 창업 로드맵을 계획하고\n한 단계씩 도약해 봅시다',
                  style: TextStyle(
                    color: AppColors.bluedark,
                    fontFamily: 'pretendard',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Gaps.v60,
                AppIcon.onschool_set_notify,
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(
              left: 24,
              right: 24,
              bottom: 24,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const NextContained(
                text: "대학교 설정하기",
                disabled: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
