// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/home_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';

class HomeNotifyRecommend extends StatefulWidget {
  const HomeNotifyRecommend({super.key});

  @override
  State<HomeNotifyRecommend> createState() => _HomeNotifyRecommendState();
}

class _HomeNotifyRecommendState extends State<HomeNotifyRecommend> {
  List<HomeAnnouncementRecModel> notifyList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAnnouncementRecommend();
  }

  void loadAnnouncementRecommend() async {
    try {
      List<HomeAnnouncementRecModel> list =
          await HomeApi.getAnnouncementRecommend();
      setState(() {
        notifyList = list;
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
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

    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '맞춤 지원 사업이 도착했어요',
            style: AppTextStyles.bd1.copyWith(color: AppColors.black),
          ),
          Gaps.v16,
          const CustomDividerH1G1(),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: notifyList.length,
            itemBuilder: (context, index) {
              HomeAnnouncementRecModel item = notifyList[index];
              return Column(
                children: [
                  Gaps.v20,
                  HomeNotifyRecommendList(
                    thisOrganize: item.keyword,
                    thisTitle: item.title,
                    thisDday: item.dday,
                    thisAnnouncementType: item.announcementType,
                  ),
                  if (index != notifyList.length - 1) Gaps.v20,
                  if (index != notifyList.length - 1) const CustomDividerH1G1(),
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
