import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';
import 'package:starting_block/constants/constants.dart';

class OncaSkeletonSystem extends StatelessWidget {
  const OncaSkeletonSystem({super.key});

  @override
  Widget build(BuildContext context) {
    int itemCount = 6;
    return SingleChildScrollView(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        shrinkWrap: true,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Column(
            children: [
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
                        width: 73,
                        color: AppColors.white,
                      ),
                      Gaps.v8,
                      Container(
                        height: 18,
                        width: 45,
                        color: AppColors.white,
                      ),
                      Gaps.v4,
                      Container(
                        height: 22,
                        width: MediaQuery.of(context).size.width,
                        color: AppColors.white,
                      ),
                      Gaps.v12,
                      Container(
                        height: 18,
                        width: 45,
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
