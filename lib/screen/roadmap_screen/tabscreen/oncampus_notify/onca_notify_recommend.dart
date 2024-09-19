import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';
import 'package:starting_block/screen/roadmap_screen/tabscreen/oncampus_notify/onca_notify_card.dart';

class OnCaNotifyRecommend extends StatelessWidget {
  final String thisSelectedText;
  final bool thisCurrentStage;
  final int roadmapId;
  final List<RoadMapOnCampusRecModel> thisOnCampusRecData;
  final bool thisRecLoading;

  const OnCaNotifyRecommend({
    super.key,
    required this.thisSelectedText,
    required this.thisCurrentStage,
    required this.roadmapId,
    required this.thisOnCampusRecData,
    required this.thisRecLoading,
  });

  @override
  Widget build(BuildContext context) {
    List<RoadMapOnCampusRecModel> onCampusRecData = thisOnCampusRecData;
    final bool isLoading = thisRecLoading;

    if (onCampusRecData.isEmpty) {
      return Container();
    }

    return Column(
      children: [
        Gaps.v24,
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: thisCurrentStage
                ? Row(
                    children: [
                      Text('추천 사업',
                          style: AppTextStyles.bd1
                              .copyWith(color: AppColors.blue)),
                      Text('이 도착했습니다',
                          style:
                              AppTextStyles.bd1.copyWith(color: AppColors.g6)),
                    ],
                  )
                : Row(
                    children: [
                      Text('도약 후',
                          style: AppTextStyles.bd1
                              .copyWith(color: AppColors.blue)),
                      Text('에 추천 사업을 받아보세요',
                          style:
                              AppTextStyles.bd1.copyWith(color: AppColors.g6)),
                    ],
                  )),
        Gaps.v16,
        isLoading
            ? const RoadMapOfcaTapCarousel()
            : Stack(
                children: [
                  SizedBox(
                    height: 130,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: onCampusRecData.length,
                      itemBuilder: (context, index) {
                        final onCampusData = onCampusRecData[index];
                        return Row(
                          children: [
                            if (index == 0) Gaps.h24,
                            OncaNotifyCard(
                              thisID: onCampusData.announcementId.toString(),
                              thisTitle: onCampusData.title,
                              thisOrganize: onCampusData.keyword,
                              index: index,
                              thisUrl: onCampusData.detailUrl,
                            ),
                            index < 2 ? Gaps.h8 : Gaps.h24,
                          ],
                        );
                      },
                    ),
                  ),
                  if (!thisCurrentStage)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: 140,
                      child: ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                          child: Container(
                            height: 140,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
        Gaps.v28,
      ],
    );
  }
}
