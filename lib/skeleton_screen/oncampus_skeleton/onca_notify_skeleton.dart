import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';
import 'package:starting_block/constants/constants.dart';

class OncaSkeletonNotify extends StatelessWidget {
  const OncaSkeletonNotify({super.key});

  @override
  Widget build(BuildContext context) {
    int itemCount = 6;
    return SingleChildScrollView(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        shrinkWrap: true,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: AppColors.g1,
            highlightColor: AppColors.g2,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 20,
                        width: 32,
                        color: AppColors.white,
                      ),
                      Gaps.v12,
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
                if (index < itemCount - 1) const CustomDividerH2G1(),
              ],
            ),
          );
        },
      ),
    );
  }
}
