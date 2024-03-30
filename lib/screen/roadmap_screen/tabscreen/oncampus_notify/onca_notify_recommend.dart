import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/oncampus_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';
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
  List<OnCampusNotifyModel> notifyList = []; // 로드된 데이터를 저장할 리스트

  final Map<String, List<String>> textToType = {
    '창업 교육': ['창업 캠프', '창업 특강', '창업 멘토링'],
    '아이디어 창출': ['창업 캠프', '창업 특강', '창업 멘토링'],
    '공간 마련': ['창업 동아리', '창업 멘토링', '기타'],
    '사업 계획서': ['창업 캠프', '창업 특강', '창업 멘토링'],
    'R&D / 시제품 제작': ['창업 멘토링', '기타'],
    '사업 검증': ['창업 멘토링', '창업 경진대회', '창업 동아리'],
    'IR Deck 작성': ['창업 멘토링'],
    '자금 확보': ['창업 멘토링'],
    '사업화': ['창업 멘토링', '창업 경진대회', '창업 동아리'],
  };

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
    final List<String> types = textToType[widget.thisSelectedText] ?? [];
    final List<OnCampusNotifyModel> loadedNotifyList =
        await OnCampusAPI.getOnCampusRoadmapRec(types: types);
    setState(() {
      notifyList = loadedNotifyList;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (notifyList.isEmpty) {
      return Container();
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Text('추천 사업',
                  style: AppTextStyles.bd1.copyWith(color: AppColors.blue)),
              Text('이 도착했습니다',
                  style: AppTextStyles.bd1.copyWith(color: AppColors.g6)),
            ],
          ),
        ),
        Gaps.v16,
        Stack(
          children: [
            SizedBox(
              height: 140,
              child: PageView.builder(
                controller: PageController(
                  viewportFraction: 312 / (360 - 16), // 카드가 차지하는 화면의 비율 조정
                  initialPage: 0,
                ),
                itemCount: notifyList.length,
                itemBuilder: (context, index) {
                  final item = notifyList[index];
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8), // 카드 간 여백 조정
                    child: OnCaNotifyCard(
                      thisProgramType: item.type,
                      thisID: item.id,
                      thisClassification: item.classification,
                      thisTitle: item.title,
                      thisUrl: item.detailurl,
                      thisStartDate: item.startdate,
                    ),
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
