import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/roadmap_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/screen/roadmap_screen/tabscreen/oncampus_system/onca_system_card.dart';

class OnCaSystemRecommend extends StatefulWidget {
  final String thisSelectedText;
  final bool thisCurrentStage;
  final int roadmapId;

  const OnCaSystemRecommend({
    super.key,
    required this.thisSelectedText,
    required this.thisCurrentStage,
    required this.roadmapId,
  });

  @override
  State<OnCaSystemRecommend> createState() => _OnCaSystemRecommendState();
}

class _OnCaSystemRecommendState extends State<OnCaSystemRecommend> {
  RoadMapSystemRecModel? systemRec;
  final GlobalKey _cardKey = GlobalKey(); // GlobalKey 추가
  double _cardHeight = 268; // 카드의 높이를 저장할 변수

  final List<String> textToType = ['창업 교육', '아이디어 창출', '자금 확보', '사업화'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateCardHeight());
    loadSystemData();
  }

  @override
  void didUpdateWidget(OnCaSystemRecommend oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.thisSelectedText != widget.thisSelectedText) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _updateCardHeight());
      loadSystemData();
    }
  }

  Future<void> loadSystemData() async {
    if (textToType.contains(widget.thisSelectedText)) {
      final systemRecData = await RoadMapApi.getSystemRec(widget.roadmapId);
      setState(() {
        systemRec = systemRecData;
      });
    } else {
      setState(() {
        systemRec = null; // Na인 경우 null 할당
      });
    }
  }

  void _updateCardHeight() {
    final RenderObject? renderObject =
        _cardKey.currentContext?.findRenderObject();
    if (renderObject is RenderBox) {
      // is 연산자를 사용하여 안전하게 타입 체크
      final size = renderObject.size;
      setState(() {
        _cardHeight = size.height; // 카드의 높이 업데이트
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (systemRec == null) {
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
            if (systemRec != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: OnCaSystemCard(
                    key: _cardKey,
                    thisTitle: systemRec!.title,
                    thisId: systemRec!.announcementId.toString(),
                    thisContent: systemRec!.content,
                    thisTarget: systemRec!.target,
                    isSaved: systemRec!.isBookmarked),
              ),
            if (!widget.thisCurrentStage)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: _cardHeight,
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
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: _cardHeight,
                child: const Center(
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
