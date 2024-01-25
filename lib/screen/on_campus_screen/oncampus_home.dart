import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class OnCampusHome extends StatefulWidget {
  const OnCampusHome({super.key});

  @override
  State<OnCampusHome> createState() => _OnCampusHomeState();
}

class _OnCampusHomeState extends State<OnCampusHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const OnCampusSearchAppBar(
        searchTapScreen: null,
        thisBackGroundColor: AppColors.bluebg,
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 272,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [244 / 272, 244 / 272], // 색상 변경 지점을 정의합니다.
                colors: [
                  AppColors.bluebg, // 0부터 324/272까지
                  AppColors.white, // 324/272부터 272/272까지
                ],
              ),
            ),
            child: Column(
              children: [
                Gaps.v16,
                Row(
                  children: [
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: Icon(Icons.school),
                    ),
                    Gaps.h4,
                    Text(
                      '서울대학교',
                      style: AppTextStyles.st2.copyWith(color: AppColors.g6),
                    ),
                    Gaps.h8,
                    Container(
                      height: 24,
                      width: 151,
                      decoration: const BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(4),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "교내 창업 지원의 통합 확인",
                          style: AppTextStyles.bd6
                              .copyWith(color: AppColors.bluedeep),
                        ),
                      ),
                    ),
                  ],
                ),
                Gaps.v28,
                FractionallySizedBox(
                  widthFactor: 1,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    height: 104,
                    decoration: const BoxDecoration(
                      color: AppColors.blue,
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 12,
                          top: 29,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "창업 지원 공고",
                                style: AppTextStyles.st2
                                    .copyWith(color: AppColors.white),
                              ),
                              Gaps.v4,
                              Text(
                                "비교과 지원 확인!",
                                style: AppTextStyles.bd6
                                    .copyWith(color: AppColors.g2),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
