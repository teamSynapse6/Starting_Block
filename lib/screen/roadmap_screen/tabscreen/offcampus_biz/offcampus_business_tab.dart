import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/api/offcampus_api_manage.dart';
import 'package:starting_block/screen/manage/model_manage.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';
import 'package:starting_block/screen/roadmap_screen/tabscreen/offcampus_biz/ofca_recommend.dart';

const List<String> validTextsBiz = [
  '창업 교육',
  '아이디어 창출',
  '공간 마련',
  '사업 계획서',
  'R&D / 시제품 제작',
  '사업 검증',
  'IR Deck 작성',
  '자금 확보',
  '사업화',
];

class TabScreenOfCaBiz extends StatefulWidget {
  final String thisSelectedText;
  final bool thisCurrentStage;

  const TabScreenOfCaBiz({
    super.key,
    required this.thisSelectedText,
    required this.thisCurrentStage,
  });

  @override
  State<TabScreenOfCaBiz> createState() => _TabScreenOfCaBizState();
}

class _TabScreenOfCaBizState extends State<TabScreenOfCaBiz> {
  List<int> savedIds = [];
  List<OffCampusModel> offCampusData = [];

  @override
  void initState() {
    super.initState();
    _loadSavedIds();
  }

  @override
  void didUpdateWidget(TabScreenOfCaBiz oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.thisSelectedText != widget.thisSelectedText) {
      _loadSavedIds();
    }
  }

  Future<void> _loadSavedIds() async {
    final ids = await getIdsForSelectedText();
    setState(() {
      savedIds = ids;
      // 새로운 thisSelectedText에 대한 반환된 ID가 없는 경우
      // offCampusData를 빈 리스트로 초기화하여 이전 데이터를 클리어함
      offCampusData = ids.isNotEmpty ? offCampusData : [];
    });

    if (ids.isNotEmpty) {
      _loadOffCampusDataByIds();
    }
  }

  Future<List<int>> getIdsForSelectedText() async {
    final prefs = await SharedPreferences.getInstance();
    String key = widget.thisSelectedText;
    String? savedDataString = prefs.getString(key);

    if (savedDataString != null) {
      List<dynamic> savedDataList = json.decode(savedDataString);
      List<int> ids = savedDataList
          .where((data) => data['classification'] == '교외사업')
          .map((data) => int.tryParse(data['id'].toString()) ?? 0)
          .toList();
      return ids;
    } else {
      return [];
    }
  }

  void _loadOffCampusDataByIds() async {
    if (savedIds.isNotEmpty) {
      try {
        final data = await OffCampusApi.getOffCampusDataByIds(savedIds);
        setState(() {
          offCampusData = data;
        });
      } catch (e) {
        // 에러 처리 로직
      }
    } else {
      setState(() {
        offCampusData = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryBG,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gaps.v24,
                if (validTextsBiz.contains(widget.thisSelectedText))
                  OfCaRecommend(
                    thisSelectedText: widget.thisSelectedText,
                    thisCurrentStage: widget.thisCurrentStage,
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('저장한 사업으로 도약하기',
                          style:
                              AppTextStyles.bd1.copyWith(color: AppColors.g6)),
                      Gaps.v4,
                      Text('신청 완료한 사업은 도약 완료 버튼으로 진행도 확인하기',
                          style:
                              AppTextStyles.bd6.copyWith(color: AppColors.g5)),
                      Gaps.v18,
                    ],
                  ),
                ),
              ],
            ),
          ),
          Consumer<RoadMapModel>(
            builder: (context, roadmapModel, child) {
              if (roadmapModel.hasUpdated) {
                _loadSavedIds().then((_) => _loadOffCampusDataByIds());
                roadmapModel.resetUpdateFlag(); // 플래그 리셋
              }
              if (savedIds.isNotEmpty) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = offCampusData[index];
                      return Container(
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          borderRadius:
                              BorderRadius.zero, // 조건부 BorderRadius 적용
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            OfCaList(
                              thisOrganize: item.organize,
                              thisID: item.id,
                              thisClassification: item.classification,
                              thisTitle: item.title,
                              thisEnddate: item.endDate,
                            ),
                            if (index < offCampusData.length - 1)
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: CustomDivider(),
                              ),
                          ],
                        ),
                      );
                    },
                    childCount: offCampusData.length,
                  ),
                );
              } else {
                // 업데이트가 없으면 여기서 처리
                return SliverToBoxAdapter(
                  child: GotoSaveItem(
                    tapAction: () {
                      IntergrateScreen.setSelectedIndexToZero(context);
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
