import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/screen/roadmap_screen/tabscreen/oncampus_system/onca_system_card.dart';

class OnCaSystemRecommend extends StatefulWidget {
  final String thisSelectedText;
  final bool thisCurrentStage;

  const OnCaSystemRecommend({
    super.key,
    required this.thisSelectedText,
    required this.thisCurrentStage,
  });

  @override
  State<OnCaSystemRecommend> createState() => _OnCaSystemRecommendState();
}

class _OnCaSystemRecommendState extends State<OnCaSystemRecommend> {
  List<OncaSystemModel> systemList = [];
  final GlobalKey _cardKey = GlobalKey(); // GlobalKey 추가
  double _cardHeight = 268; // 카드의 높이를 저장할 변수

  final Map<String, dynamic> textToType = {
    '창업 교육': ['학점교류제', '창업연계전공', '창업실습'],
    '아이디어 창출': ['창업실습'],
    '공간 마련': 'Na',
    '사업 계획서': 'Na',
    'R&D / 시제품 제작': 'Na',
    '사업 검증': 'Na',
    'IR Deck 작성': 'Na',
    '자금 확보': ['교내창업장학금', '국가장학금'],
    '사업화': ['창업휴학제도', '창업현장실습'],
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateCardHeight());
    // loadSystemData();
  }

  @override
  void didUpdateWidget(OnCaSystemRecommend oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.thisSelectedText != widget.thisSelectedText) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _updateCardHeight());
      // loadSystemData();
    }
  }

  // Future<void> loadSystemData() async {
  //   var types = textToType[widget.thisSelectedText];
  //   // 'Na'를 체크하여 메소드 호출을 건너뛰거나 빈 리스트 할당
  //   if (types != 'Na' && types is List<String>) {
  //     var data = await OnCampusAPI.getOnCampusSystemRec(types);
  //     setState(() {
  //       systemList = [data]; // 결과를 리스트에 할당
  //     });

  //     setState(() {
  //       systemList = []; // Na인 경우 빈 리스트 할당
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
    if (systemList.isEmpty) {
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
            if (systemList.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: OnCaSystemCard(
                  key: _cardKey,
                  thisTitle: systemList[0].title,
                  thisId: systemList[0].systemId.toString(),
                  thisContent: systemList[0].content,
                  thisTarget: systemList[0].target,
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
