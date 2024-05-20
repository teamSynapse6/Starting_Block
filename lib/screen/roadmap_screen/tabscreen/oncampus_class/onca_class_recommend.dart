import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/roadmap_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/screen/roadmap_screen/tabscreen/oncampus_class/onca_class_card.dart';

class OnCaClassRecommend extends StatefulWidget {
  final String thisSelectedText;
  final bool thisCurrentStage;
  final int roadmapId;

  const OnCaClassRecommend({
    super.key,
    required this.thisSelectedText,
    required this.thisCurrentStage,
    required this.roadmapId,
  });

  @override
  State<OnCaClassRecommend> createState() => _OnCaClassRecState();
}

class _OnCaClassRecState extends State<OnCaClassRecommend> {
  RoadMapClassRecModel? classRec;
  final GlobalKey _cardKeyFirClass = GlobalKey(); // GlobalKey 추가
  double _cardHeight = 268; // 카드의 높이를 저장할 변수

  final List boolToClass = ['창업 교육', '아이디어 창출', '공간 마련', '사업 계획서'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateCardHeight());
    loadClassData();
  }

  @override
  void didUpdateWidget(OnCaClassRecommend oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.thisSelectedText != widget.thisSelectedText) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _updateCardHeight());
      loadClassData();
    }
  }

  Future<void> loadClassData() async {
    // boolToClass에서 현재 선택된 텍스트에 대한 값이 true인지 확인
    if (boolToClass.contains(widget.thisSelectedText)) {
      final classRecData = await RoadMapApi.getClassRec(widget.roadmapId);
      setState(() {
        classRec = classRecData;
      });
    } else {
      setState(() {
        classRec = null;
      });
    }
  }

  void _updateCardHeight() {
    final RenderObject? renderObject =
        _cardKeyFirClass.currentContext?.findRenderObject();
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
    if (classRec == null) {
      return Container();
    }

    return Column(
      children: [
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
        Stack(
          children: [
            if (classRec != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: OnCaClassCard(
                  key: _cardKeyFirClass,
                  thisTitle: classRec!.title,
                  thisId: classRec!.lectureId.toString(),
                  thisLiberal: classRec!.liberal,
                  thisCredit: classRec!.credit.toString(),
                  thisContent: classRec!.content,
                  thisSession: classRec!.session.toString(),
                  thisInstructor: classRec!.instructor,
                  isSaved: classRec!.isBookmarked,
                ),
              ),
            if (!widget.thisCurrentStage)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: _cardHeight,
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
