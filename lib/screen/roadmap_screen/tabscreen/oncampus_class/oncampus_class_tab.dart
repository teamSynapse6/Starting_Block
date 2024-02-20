import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/api/oncampus_api_manage.dart';
import 'package:starting_block/screen/manage/model_manage.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';
import 'package:starting_block/screen/roadmap_screen/tabscreen/oncampus_class/onca_class_recommend.dart';

const List<String> validTextsClass = [
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

class TabScreenOnCaClass extends StatefulWidget {
  final String thisSelectedText;
  final bool thisCurrentStage;

  const TabScreenOnCaClass({
    super.key,
    required this.thisSelectedText,
    required this.thisCurrentStage,
  });

  @override
  State<TabScreenOnCaClass> createState() => _TabScreenOnCaClassState();
}

class _TabScreenOnCaClassState extends State<TabScreenOnCaClass> {
  List<int> savedIds = [];
  List<OnCampusClassModel> onCampusClassData = [];

  @override
  void initState() {
    super.initState();
    _loadSavedIds();
  }

  @override
  void didUpdateWidget(TabScreenOnCaClass oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.thisSelectedText != widget.thisSelectedText) {
      _loadSavedIds();
    }
  }

  Future<void> _loadSavedIds() async {
    final ids = await getIdsForSelectedText();
    setState(() {
      savedIds = ids;
      onCampusClassData = ids.isNotEmpty ? onCampusClassData : [];
    });

    if (ids.isNotEmpty) {
      _loadOnCampusClassDataByIds();
    }
  }

  Future<List<int>> getIdsForSelectedText() async {
    final prefs = await SharedPreferences.getInstance();
    String key = widget.thisSelectedText;
    String? savedDataString = prefs.getString(key);

    if (savedDataString != null) {
      List<dynamic> savedDataList = json.decode(savedDataString);
      List<int> ids = savedDataList
          .where((data) => data['classification'] == '창업강의')
          .map((data) => int.tryParse(data['id'].toString()) ?? 0)
          .toList();
      return ids;
    } else {
      return [];
    }
  }

  void _loadOnCampusClassDataByIds() async {
    if (savedIds.isNotEmpty) {
      try {
        final data = await OnCampusAPI.getOnCampusClassByIds(savedIds);
        setState(() {
          onCampusClassData = data;
        });
      } catch (e) {
        // 에러 처리 로직
      }
    } else {
      setState(() {
        onCampusClassData = [];
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
                if (validTextsClass.contains(widget.thisSelectedText))
                  OnCaClassRecommend(
                    thisSelectedText: widget.thisSelectedText,
                    thisCurrentStage: widget.thisCurrentStage,
                  ),
                Gaps.v28,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('저장한 사업으로 도약하기',
                          style:
                              AppTextStyles.st2.copyWith(color: AppColors.g6)),
                      Gaps.v4,
                      Text('신청 완료한 사업은 도약 완료 버튼으로 진행도 확인하기',
                          style: AppTextStyles.caption
                              .copyWith(color: AppColors.g5)),
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
                _loadSavedIds().then((_) => _loadOnCampusClassDataByIds());
                roadmapModel.resetUpdateFlag();
              }
              if (savedIds.isNotEmpty) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = onCampusClassData[index];
                      return Container(
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.zero,
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            OnCaListClass(
                              thisTitle: item.title,
                              thisId: item.id,
                              thisLiberal: item.liberal,
                              thisCredit: item.credit,
                              thisContent: item.content,
                              thisSession: item.session,
                            ),
                            if (index < onCampusClassData.length - 1)
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: CustomDivider(),
                              ),
                          ],
                        ),
                      );
                    },
                    childCount: onCampusClassData.length,
                  ),
                );
              } else {
                return SliverToBoxAdapter(
                  child: GotoSaveItem(
                    tapAction: () {
                      IntergrateScreen.setSelectedIndexToOne(context);
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
