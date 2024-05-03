import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:starting_block/constants/constants.dart';

class OncaSkeletonSearch extends StatelessWidget {
  const OncaSkeletonSearch({super.key});

  @override
  Widget build(BuildContext context) {
    int itemCount = 6;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Column(
          children: [
            if (index == 0) Gaps.v4,
            Shimmer.fromColors(
              baseColor: AppColors.g1,
              highlightColor: AppColors.g2,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 32,
                      height: 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: AppColors.white,
                      ),
                    ),
                    Gaps.v10,
                    Container(
                      height: 22,
                      width: MediaQuery.of(context).size.width,
                      color: AppColors.white,
                    ),
                    Gaps.v8,
                    Container(
                      height: 18,
                      width: 98,
                      color: AppColors.white,
                    ),
                  ],
                ),
              ),
            ),
            if (index < itemCount - 1) const CustomDividerH2G1()
          ],
        );
      },
    );
  }
}
