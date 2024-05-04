import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shimmer/shimmer.dart';
import 'package:starting_block/constants/constants.dart';

class OncaSkeletonClass extends StatelessWidget {
  const OncaSkeletonClass({super.key});

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
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
                        width: 136,
                        color: AppColors.white,
                      ),
                      Gaps.v14,
                      const CustomDividerH2G1(),
                      Gaps.v16,
                      Row(
                        children: [
                          Container(
                            height: 20,
                            width: 57,
                            color: AppColors.white,
                          ),
                          Gaps.h8,
                          Container(
                            height: 20,
                            width: 41,
                            color: AppColors.white,
                          ),
                          Gaps.h8,
                          Container(
                            height: 20,
                            width: 77,
                            color: AppColors.white,
                          ),
                        ],
                      ),
                      Gaps.v12,
                      Container(
                        height: 18,
                        width: 45,
                        color: AppColors.white,
                      ),
                      Gaps.v4,
                      Container(
                        height: 18,
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
                        height: 18,
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
