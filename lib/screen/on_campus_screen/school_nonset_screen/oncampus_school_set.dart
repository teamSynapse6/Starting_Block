import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/on_campus_screen/school_nonset_screen/oncampus_school_search.dart';

class OnCampusSchoolSet extends StatelessWidget {
  const OnCampusSchoolSet({super.key});

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
                      '학교를 설정한 뒤,\n교내 창업 지원을 한 번에 확인해보세요',
                      style: AppTextStyles.st2.copyWith(color: AppColors.g6),
                    ),
                  ),
                  Positioned(
                    top: 182,
                    left: 0,
                    right: 0,
                    child: SizedBox(
                      width: 312,
                      child: AppIcon.school_illustrate,
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
                    return const OnCampusSchoolSearch();
                  }));
                },
                child: const NextContained(
                  disabled: false,
                  text: '대학교 설정하기',
                ),
              ),
            ),
          ],
        ));
  }
}
