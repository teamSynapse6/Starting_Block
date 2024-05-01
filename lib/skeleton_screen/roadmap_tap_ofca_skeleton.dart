import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:starting_block/constants/constants.dart';

class RoadMapOfcaTabSkeleton extends StatelessWidget {
  const RoadMapOfcaTabSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    int itemCount = 6;
    int lastIndex = itemCount - 1;

    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: index == 0
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(2),
                      topRight: Radius.circular(2),
                    )
                  : index == lastIndex
                      ? const BorderRadius.only(
                          bottomLeft: Radius.circular(2),
                          bottomRight: Radius.circular(2),
                        )
                      : null,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Gaps.v16,
                  Shimmer.fromColors(
                    baseColor: AppColors.g1,
                    highlightColor: AppColors.g2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 32,
                          height: 20,
                          color: AppColors.white,
                        ),
                        Gaps.v10,
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 22,
                          color: AppColors.white,
                        ),
                        Gaps.v10,
                        Container(
                          width: 32,
                          height: 20,
                          color: AppColors.white,
                        ),
                      ],
                    ),
                  ),
                  Gaps.v16,
                  if (index != lastIndex) const CustomDividerH2G1(),
                ],
              ),
            ),
          );
        },
        childCount: itemCount, // 스켈레톤 아이템 수 설정
      ),
    );
  }
}

class RoadMapOfcaTapCarousel extends StatelessWidget {
  const RoadMapOfcaTapCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    int itemCount = 5;

    return Row(
      children: [
        Gaps.h24,
        for (int i = 0; i < itemCount; i++) // for 문을 사용해 컨테이너를 5번 반복
          Row(
            children: [
              Container(
                width: 152,
                height: 130,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(2),
                ),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                child: Shimmer.fromColors(
                  baseColor: AppColors.g1,
                  highlightColor: AppColors.g2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 20,
                        color: AppColors.white,
                      ),
                      Gaps.v14,
                      Container(
                        height: 20,
                        color: AppColors.white,
                      ),
                      Gaps.v2,
                      Container(
                        height: 20,
                        color: AppColors.white,
                      ),
                      Gaps.v2,
                      Container(
                        height: 20,
                        color: AppColors.white,
                      ),
                    ],
                  ),
                ),
              ),
              Gaps.h8,
            ],
          ),
      ],
    );
  }
}
