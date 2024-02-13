import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/api/oncampus_api_manage.dart'; // Import 수정
import 'package:starting_block/screen/manage/model_manage.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';

const List<String> validTextsNotify = [
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

class TabScreenOnCaNotify extends StatefulWidget {
  final String thisSelectedText;
  final bool thisCurrentStage;

  const TabScreenOnCaNotify({
    super.key,
    required this.thisSelectedText,
    required this.thisCurrentStage,
  });

  @override
  State<TabScreenOnCaNotify> createState() => _TabScreenOnCaNotifyState();
}

class _TabScreenOnCaNotifyState extends State<TabScreenOnCaNotify> {
  List<int> savedIds = [];
  List<OnCampusNotifyModel> onCampusNotifyData =
      []; // 변경: OffCampusModel을 OnCampusNotifyModel로 변경

  @override
  void initState() {
    super.initState();
    _loadSavedIds();
  }

  @override
  void didUpdateWidget(TabScreenOnCaNotify oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.thisSelectedText != widget.thisSelectedText) {
      _loadSavedIds();
    }
  }

  Future<void> _loadSavedIds() async {
    final ids = await getIdsForSelectedText();
    setState(() {
      savedIds = ids;
      onCampusNotifyData =
          ids.isNotEmpty ? onCampusNotifyData : []; // 이전 데이터를 클리어함
    });

    if (ids.isNotEmpty) {
      _loadOnCampusNotifyDataByIds(); // 변경: _loadOffCampusDataByIds()를 _loadOnCampusNotifyDataByIds()로 변경
    }
  }

  Future<List<int>> getIdsForSelectedText() async {
    final prefs = await SharedPreferences.getInstance();
    String key = widget.thisSelectedText;
    String? savedDataString = prefs.getString(key);

    if (savedDataString != null) {
      List<dynamic> savedDataList = json.decode(savedDataString);
      List<int> ids = savedDataList
          .where((data) => data['classification'] == '교내사업')
          .map((data) => int.tryParse(data['id'].toString()) ?? 0)
          .toList();
      return ids;
    } else {
      return [];
    }
  }

  void _loadOnCampusNotifyDataByIds() async {
    if (savedIds.isNotEmpty) {
      try {
        final data = await OnCampusAPI.getOnCampusNotifyByIds(
            savedIds); // 변경: OffCampusApiService.getOffCampusDataByIds()를 OnCampusAPI.getOnCampusNotifyByIds()로 변경
        setState(() {
          onCampusNotifyData = data;
        });
      } catch (e) {
        // 에러 처리 로직
      }
    } else {
      setState(() {
        onCampusNotifyData = [];
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
                if (validTextsNotify.contains(widget.thisSelectedText))
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      children: [
                        Text('추천 사업',
                            style: AppTextStyles.st2
                                .copyWith(color: AppColors.blue)),
                        Text('이 도착했습니다',
                            style: AppTextStyles.st2
                                .copyWith(color: AppColors.g6)),
                      ],
                    ),
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
                // RoadMapModel이 업데이트 되었다면 다시 아이디를 불러오고
                // API를 통해 데이터를 불러오는 메소드를 실행
                _loadSavedIds().then((_) => _loadOnCampusNotifyDataByIds());
                roadmapModel.resetUpdateFlag(); // 플래그 리셋
              }
              if (savedIds.isNotEmpty) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = onCampusNotifyData[
                          index]; // 변경: OffCampusModel을 OnCampusNotifyModel로 변경
                      // ListTile로 반환하여 title만 표시
                      return Container(
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          borderRadius:
                              BorderRadius.zero, // 조건부 BorderRadius 적용
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            OnCaListNotify(
                              thisProgramType: item.type,
                              thisID: item.id,
                              thisClassification: item.classification,
                              thisTitle: item.title,
                              thisUrl: item.detailurl,
                            ),
                            if (index < onCampusNotifyData.length - 1)
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: CustomDivider(),
                              ),
                          ],
                        ),
                      );
                    },
                    childCount: onCampusNotifyData
                        .length, // 변경: OffCampusModel을 OnCampusNotifyModel로 변경
                  ),
                );
              } else {
                // 업데이트가 없으면 여기서 처리
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
