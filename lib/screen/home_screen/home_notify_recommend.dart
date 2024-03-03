import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class HomeNotifyRecommend extends StatefulWidget {
  const HomeNotifyRecommend({super.key});

  @override
  State<HomeNotifyRecommend> createState() => _HomeNotifyRecommendState();
}

class _HomeNotifyRecommendState extends State<HomeNotifyRecommend> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '맞춤 지원 사업이 도착했어요',
              style: AppTextStyles.bd1.copyWith(color: AppColors.black),
            ),
            Gaps.v16,
            const CustomDividerH1G1(),
            const HomeNotifyRecommendList(),
          ],
        ),
      ),
    );
  }
}
