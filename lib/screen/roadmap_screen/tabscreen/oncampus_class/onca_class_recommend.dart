import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/screen/roadmap_screen/tabscreen/oncampus_class/onca_class_card.dart';

class OnCaClassRecommend extends StatefulWidget {
  final String thisSelectedText;
  final bool thisCurrentStage;

  const OnCaClassRecommend({
    super.key,
    required this.thisSelectedText,
    required this.thisCurrentStage,
  });

  @override
  State<OnCaClassRecommend> createState() => _OnCaClassRecState();
}

class _OnCaClassRecState extends State<OnCaClassRecommend> {
  List<OncaClassModel> classList = [];
  final GlobalKey _cardKey = GlobalKey(); // GlobalKey 추가
  double _cardHeight = 268; // 카드의 높이를 저장할 변수

  final Map<String, bool> boolToClass = {
    '창업 교육': true,
    '아이디어 창출': true,
    '공간 마련': true,
    '사업 계획서': true,
    'R&D / 시제품 제작': false,
    '사업 검증': false,
    'IR Deck 작성': false,
    '자금 확보': false,
    '사업화': false,
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateCardHeight());
    // loadClassData();
  }

  @override
  void didUpdateWidget(OnCaClassRecommend oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.thisSelectedText != widget.thisSelectedText) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _updateCardHeight());
      // loadClassData();
    }
  }

  // Future<void> loadClassData() async {
  //   // boolToClass에서 현재 선택된 텍스트에 대한 값이 true인지 확인
  //   if (boolToClass[widget.thisSelectedText] ?? false) {
  //     final OnCampusClassModel classData =
  //         await OnCampusAPI.getOnCampusClassRec();
  //     setState(() {
  //       classList = [classData];
  //     });
  //   } else {
  //     setState(() {
  //       classList = [];
  //     });
  //   }
  // }

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
    if (classList.isEmpty) {
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
            if (classList.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: OnCaClassCard(
                  key: _cardKey,
                  thisTitle: classList[0].title,
                  thisId: classList[0].lectureId.toString(),
                  thisLiberal: classList[0].liberal,
                  thisCredit: classList[0].credit.toString(),
                  thisContent: classList[0].content,
                  thisSession: classList[0].session.toString(),
                  thisInstructor: classList[0].instructor,
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
