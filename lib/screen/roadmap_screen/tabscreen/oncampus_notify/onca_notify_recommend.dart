import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/roadmap_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';
import 'package:starting_block/screen/roadmap_screen/tabscreen/oncampus_notify/onca_notify_card.dart';

class OnCaNotifyRecommend extends StatefulWidget {
  final String thisSelectedText;
  final bool thisCurrentStage;
  final int roadmapId;

  const OnCaNotifyRecommend({
    super.key,
    required this.thisSelectedText,
    required this.thisCurrentStage,
    required this.roadmapId,
  });

  @override
  State<OnCaNotifyRecommend> createState() => _OnCaNotifyRecommendState();
}

class _OnCaNotifyRecommendState extends State<OnCaNotifyRecommend> {
  List<RoadMapOnCampusRecModel> _onCampusRecData = []; // 로드된 데이터를 저장할 리스트
  final bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadOnCaNotifyRec(); // 데이터 로드
  }

  @override
  void didUpdateWidget(OnCaNotifyRecommend oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.thisSelectedText != widget.thisSelectedText) {
      loadOnCaNotifyRec();
    }
  }

  Future<void> loadOnCaNotifyRec() async {
    final onCampusRecData = await RoadMapApi.getOnCampusRec(widget.roadmapId);
    setState(() {
      _onCampusRecData = onCampusRecData;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_onCampusRecData.isEmpty) {
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
        !_isLoading
            ? const RoadMapOfcaTapCarousel()
            : Stack(
                children: [
                  SizedBox(
                    height: 130,
                    child: ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: _onCampusRecData.length,
                      itemBuilder: (context, index) {
                        final onCampusData = _onCampusRecData[index];
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
                  if (!widget.thisCurrentStage)
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      height: 140,
                      child: ClipRRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: Container(
                            height: 140,
                            width: MediaQuery.of(context).size.width,
                            color: Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                  if (!widget.thisCurrentStage)
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
        Gaps.v28,
      ],
    );
  }
}
