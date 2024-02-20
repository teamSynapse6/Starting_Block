import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/api/oncampus_api_manage.dart';
import 'package:starting_block/screen/manage/model_manage.dart';
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
  List<OnCampusClassModel> classList = [];

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

    loadClassData();
  }

  Future<void> loadClassData() async {
    // boolToClass에서 현재 선택된 텍스트에 대한 값이 true인지 확인
    if (boolToClass[widget.thisSelectedText] ?? false) {
      try {
        final OnCampusClassModel classData =
            await OnCampusAPI.getOnCampusClassRec();
        setState(() {
          classList = [classData];
        });
      } catch (e) {
        print("클래스 데이터 로딩 중 오류 발생: $e");
      }
    } else {
      setState(() {
        classList = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                itemCount: classList.length,
                itemBuilder: (context, index) {
                  final item = classList[index];
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8), // 카드 간 여백 조정
                    child: OnCaClassCard(
                      thisTitle: item.title,
                      thisId: item.id,
                      thisLiberal: item.liberal,
                      thisCredit: item.credit,
                      thisContent: item.content,
                      thisSession: item.session,
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
