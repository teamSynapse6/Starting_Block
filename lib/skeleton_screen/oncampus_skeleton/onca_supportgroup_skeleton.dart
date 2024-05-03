import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';
import 'package:starting_block/constants/constants.dart';

class OncaSkeletonSupportGroup extends StatelessWidget {
  const OncaSkeletonSupportGroup({super.key});

  @override
  Widget build(BuildContext context) {
    int itemCount = 5;
    return SingleChildScrollView(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        shrinkWrap: true,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (index == 0) Gaps.v20,
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Shimmer.fromColors(
                  baseColor: AppColors.g1,
                  highlightColor: AppColors.g2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 22,
                        width: 101,
                        color: AppColors.white,
                      ),
                      Gaps.v4,
                      Container(
                        height: 22,
                        width: MediaQuery.of(context).size.width,
                        color: AppColors.white,
                      ),
                      Gaps.v4,
                      Container(
                        height: 22,
                        width: MediaQuery.of(context).size.width,
                        color: AppColors.white,
                      ),
                    ],
                  ),
                ),
              ),
              if (index < itemCount - 1) Gaps.v16,
            ],
          );
        },
      ),
    );
  }
}
