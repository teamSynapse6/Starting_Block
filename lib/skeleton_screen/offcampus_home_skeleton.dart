import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:starting_block/constants/constants.dart';

class OffCampusHomeSkeleton extends StatelessWidget {
  const OffCampusHomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 4,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppColors.g1,
          highlightColor: AppColors.g3,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(
              top: 16,
              left: 24,
              right: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 4,
                  children: [
                    for (int i = 0; i < 3; i++)
                      Container(
                        width: 32,
                        height: 20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2),
                          color: AppColors.white,
                        ),
                      ),
                  ],
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
                Gaps.v2,
                Container(
                  height: 18,
                  width: 98,
                  color: AppColors.white,
                ),
                Gaps.v16,
                const CustomDividerH2G1()
              ],
            ),
          ),
        );
      },
    );
  }
}
