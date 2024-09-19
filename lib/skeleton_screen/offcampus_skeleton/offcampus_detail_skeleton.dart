import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';
import 'package:starting_block/constants/constants.dart';

class OffCampusDetailSkeleton extends StatelessWidget {
  const OffCampusDetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.g1,
      highlightColor: AppColors.g2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gaps.v8,
            Container(height: 26, width: 50, color: AppColors.white),
            Gaps.v20,
            Container(
                height: 20, width: double.infinity, color: AppColors.white),
            Gaps.v12,
            Container(
                height: 20, width: double.infinity, color: AppColors.white),
            Gaps.v20,
            Container(height: 10, width: 116, color: AppColors.white),
            Gaps.v13,
            Container(height: 10, width: 116, color: AppColors.white),
            Gaps.v17,
            const CustomDividerH2G1(),
            Gaps.v20,
            Container(height: 10, width: 47, color: AppColors.white),
            Gaps.v12,
            Container(
                height: 15, width: double.infinity, color: AppColors.white),
            Gaps.v27,
            Container(height: 10, width: 47, color: AppColors.white),
            Gaps.v12,
            Container(
                height: 15, width: double.infinity, color: AppColors.white),
            Gaps.v27,
            Container(height: 10, width: 47, color: AppColors.white),
            Gaps.v12,
            Container(
                height: 15, width: double.infinity, color: AppColors.white),
            Gaps.v5,
            Container(height: 15, width: 77, color: AppColors.white),
            Gaps.v40,
            Row(
              children: [
                Expanded(child: Container(height: 44, color: AppColors.white)),
                Gaps.h8,
                Expanded(child: Container(height: 44, color: AppColors.white)),
              ],
            ),
            Gaps.v40,
          ],
        ),
      ),
    );
  }
}

class OffCampusDetailRecommendSkeleton extends StatelessWidget {
  const OffCampusDetailRecommendSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    int thisItemCount = 3;

    return Shimmer.fromColors(
      baseColor: AppColors.g1,
      highlightColor: AppColors.g2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gaps.v36,
            Container(height: 20, width: 177, color: AppColors.white),
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: thisItemCount,
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gaps.v20,
                      Row(
                        children: [
                          Container(
                              width: 72, height: 20, color: AppColors.white),
                          Gaps.h4,
                          Container(
                              width: 58, height: 20, color: AppColors.white),
                          Gaps.h4,
                          Container(
                              width: 43, height: 20, color: AppColors.white)
                        ],
                      ),
                      Gaps.v12,
                      Container(
                        width: double.infinity,
                        height: 20,
                        color: AppColors.white,
                      ),
                      Gaps.v10,
                      Container(width: 116, height: 10, color: AppColors.white),
                      Gaps.v10,
                      Container(width: 116, height: 10, color: AppColors.white),
                      Gaps.v20,
                      const CustomDividerH2G1(),
                    ],
                  );
                })
          ],
        ),
      ),
    );
  }
}
