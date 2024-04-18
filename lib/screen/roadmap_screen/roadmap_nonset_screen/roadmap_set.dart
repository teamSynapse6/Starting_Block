import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/screen_manage.dart';

class RoadMapSet extends StatelessWidget {
  const RoadMapSet({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Container(
            color: AppColors.bluebg,
          ),
        ),
        body: Column(
          children: [
            Container(
              height: 400 - 24,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  stops: [0.0, 395 / 400, 1.0],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.bluebg,
                    AppColors.bluebg,
                    AppColors.white,
                  ],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 96,
                    left: 24,
                    child: Text(
                      '로드맵을 설정한 뒤,\n나만의 창업 로드맵을 계획해보세요',
                      style: AppTextStyles.st2.copyWith(color: AppColors.g6),
                    ),
                  ),
                  Positioned(
                    top: 182,
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      width: 312,
                      child: AppIcon.roadmap_illustrate,
                    ),
                  ),
                ],
              ),
            ),
            Gaps.v64,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const RoadmapListSet();
                  }));
                },
                child: const NextContained(
                  disabled: false,
                  text: '로드맵 설정하고 시작하기',
                ),
              ),
            ),
          ],
        ));
  }
}
