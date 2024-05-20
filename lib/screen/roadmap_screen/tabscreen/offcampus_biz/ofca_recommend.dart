import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';

class OfCaRecommend extends StatelessWidget {
  final String thisSelectedText;
  final bool thisCurrentStage;
  final int roadmapId;
  final List<RoadMapOffCampusRecModel> thisOffCampusRecData;
  final bool isRecLoading;

  const OfCaRecommend({
    super.key,
    required this.thisSelectedText,
    required this.thisCurrentStage,
    required this.roadmapId,
    required this.thisOffCampusRecData,
    required this.isRecLoading,
  });

  @override
  Widget build(BuildContext context) {
    final List<RoadMapOffCampusRecModel> offCampusRecData =
        thisOffCampusRecData;
    final bool isLoading = isRecLoading;

    if (offCampusRecData.isEmpty) {
      return Container();
    }

    return Column(
      children: [
        Gaps.v24,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              AppIcon.mail,
              Gaps.h6,
              Text('추천 사업',
                  style: AppTextStyles.bd1.copyWith(color: AppColors.blue)),
              Text('이 도착했습니다',
                  style: AppTextStyles.bd1.copyWith(color: AppColors.g6)),
            ],
          ),
        ),
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
                      itemCount: offCampusRecData.length,
                      itemBuilder: (context, index) {
                        final offCampusRec = offCampusRecData[index];
                        return Row(
                          children: [
                            if (index == 0) Gaps.h24,
                            OfCaCardOne(
                              thisOrganize: offCampusRec.department,
                              thisID: offCampusRec.announcementId.toString(),
                              thisTitle: offCampusRec.title,
                              index: index,
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
                  if (!thisCurrentStage)
                    const Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: 140,
                      child: Center(
                        child: RoadMapStepNotify(),
                      ),
                    ),
                ],
              ),
        Gaps.v16,
      ],
    );
  }
}
