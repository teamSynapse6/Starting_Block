import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:starting_block/constants/constants.dart';

class HomeNotifySkeleton extends StatelessWidget {
  const HomeNotifySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
      child: Shimmer.fromColors(
        baseColor: AppColors.g1,
        highlightColor: AppColors.g2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 200,
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: AppColors.white,
              ),
            ),
            Gaps.v20,
            const CustomDividerH1G1(),
            ListView.builder(
              itemCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gaps.v20,
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 20,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: AppColors.white),
                        ),
                        Gaps.h8,
                        Container(
                          width: 32,
                          height: 20,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(2),
                              color: AppColors.white),
                        ),
                      ],
                    ),
                    Gaps.v13,
                    Container(
                      width: double.infinity,
                      height: 16,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: AppColors.white),
                    ),
                    Gaps.v6,
                    Container(
                      width: double.infinity,
                      height: 16,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: AppColors.white),
                    ),
                    Gaps.v18,
                    Container(
                      width: 52,
                      height: 10,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: AppColors.white),
                    ),
                    if (index != 1) Gaps.v22,
                    if (index != 1) const CustomDividerH1G1(),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
