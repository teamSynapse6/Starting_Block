import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/screen_manage.dart';
import 'package:starting_block/screen/roadmap_screen/tabscreen/oncampus_notify/onca_notify_card.dart';

class OnCaNotifyRecommend extends StatefulWidget {
  final String thisSelectedText;
  final bool thisCurrentStage;

  const OnCaNotifyRecommend({
    super.key,
    required this.thisSelectedText,
    required this.thisCurrentStage,
  });

  @override
  State<OnCaNotifyRecommend> createState() => _OnCaNotifyRecommendState();
}

class _OnCaNotifyRecommendState extends State<OnCaNotifyRecommend> {
  List notifyList = []; // 로드된 데이터를 저장할 리스트
  final bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // loadOnCaNotifyRec(); // 데이터 로드
  }

  @override
  void didUpdateWidget(OnCaNotifyRecommend oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.thisSelectedText != widget.thisSelectedText) {
      // loadOnCaNotifyRec();
    }
  }

  // Future<void> loadOnCaNotifyRec() async {
  //   final List<String> types = textToType[widget.thisSelectedText] ?? [];
  //   final List<OnCampusNotifyModel> loadedNotifyList =
  //       await OnCampusAPI.getOnCampusRoadmapRec(types: types);
  //   setState(() {
  //     notifyList = loadedNotifyList;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    // if (notifyList.isEmpty) {
    //   return Container();
    // }

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
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        // final item = notifyList[index];
                        return Row(
                          children: [
                            if (index == 0) Gaps.h24,
                            OncaNotifyCard(
                              thisID: 'item.id',
                              thisTitle: 'item.title',
                              thisOrganize: 'aaaa',
                              index: index,
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
