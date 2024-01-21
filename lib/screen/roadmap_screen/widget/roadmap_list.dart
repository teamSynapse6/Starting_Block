import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';

class RoadMapList extends StatefulWidget {
  final Function(String, int, bool) onSelectedRoadmapChanged;

  const RoadMapList({
    Key? key,
    required this.onSelectedRoadmapChanged,
  }) : super(key: key);

  @override
  State<RoadMapList> createState() => _RoadMapListState();

  // Public 메서드로 resetToCurrentStage 추가
  static void resetToCurrentStage(GlobalKey<State<RoadMapList>> key) {
    (key.currentState as _RoadMapListState?)?.resetToCurrentStage();
  }
}

class _RoadMapListState extends State<RoadMapList> {
  int? selectedRoadmapIndex;
  String? selectedRoadmapText;
  final GlobalKey<State<RoadMapList>> key = GlobalKey();

  // Getter를 추가하여 외부에서 선택된 텍스트에 접근할 수 있게 함
  String? getSelectedRoadmapText() {
    return selectedRoadmapText;
  }

  void _onEditTap() async {
    bool result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RoadMapEdit()),
    );
    if (result) {
      resetToCurrentStage();
    }
  }

  void resetToCurrentStage() {
    // Provider를 통해 RoadMapModel의 인스턴스를 가져옴
    final roadmapModel = Provider.of<RoadMapModel>(context, listen: false);
    final roadmapItems = roadmapModel.roadmapList;
    final roadmapCheckItems = roadmapModel.roadmapListCheck;
    // '현단계' 인덱스 찾기
    final int currentStageIndex = roadmapCheckItems.indexOf('현단계');

    // '현단계' 텍스트 찾기
    final String currentStageText = currentStageIndex != -1
        ? roadmapItems[currentStageIndex]
        : ''; // 혹은 기본값 설정

    setState(() {
      selectedRoadmapIndex = currentStageIndex;
      selectedRoadmapText = currentStageText;
      widget.onSelectedRoadmapChanged(
          currentStageText, currentStageIndex, currentStageIndex != -1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final roadmapModel = Provider.of<RoadMapModel>(context);
    final roadmapItems = roadmapModel.roadmapList;
    final roadmapCheckItems = roadmapModel.roadmapListCheck;

    // '현단계' 인덱스 찾기 및 선택 상태 업데이트
    int currentStageIndex = roadmapCheckItems.indexOf('현단계');
    if (currentStageIndex != -1 && selectedRoadmapIndex == null) {
      // '현단계'가 있고, 아직 선택된 항목이 없는 경우
      setState(() {
        selectedRoadmapText = roadmapItems[currentStageIndex];
        selectedRoadmapIndex = currentStageIndex;
        // 콜백 함수 호출하여 상태 변경 반영
        widget.onSelectedRoadmapChanged(
            selectedRoadmapText!, selectedRoadmapIndex!, true);
      });
    } else if (roadmapItems.isNotEmpty && selectedRoadmapIndex == null) {
      // 초기 상태에서 '현단계'가 없고, 선택된 항목이 없는 경우 첫 번째 항목을 기본값으로 설정
      selectedRoadmapText = roadmapItems[0];
      selectedRoadmapIndex = 0;
    }

    void roadMapTap(BuildContext context) async {
      // '현 단계'의 인덱스를 구하는 로직을 StatefulBuilder 외부로 이동
      await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) {
          return Consumer<RoadMapModel>(
            builder: (context, roadmapModel, child) {
              print(
                  'RoadMapList가 업데이트되었습니다. 현재 로드맵 리스트: ${roadmapModel.roadmapList}');
              print('RoadMapList의 단계 업데이트: ${roadmapModel.roadmapListCheck}');

              final roadmapItems = roadmapModel.roadmapList;
              final roadmapCheckItems =
                  roadmapModel.roadmapListCheck; // roadmapListCheck를 가져옴

              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setStateModal) {
                  return Container(
                    color: AppColors.white,
                    height: 600,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Gaps.v18,
                        Row(
                          children: [
                            const Spacer(),
                            GestureDetector(
                              onTap: _onEditTap,
                              child: SizedBox(
                                height: 32,
                                width: 76,
                                child: Text(
                                  '단계 편집',
                                  style: AppTextStyles.btn1
                                      .copyWith(color: AppColors.g6),
                                ),
                              ),
                            ),
                            Gaps.h12,
                          ],
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: roadmapItems.length,
                            itemBuilder: (BuildContext context, int index) {
                              String roadmapList = roadmapItems[index];
                              String? roadmapCheck =
                                  roadmapCheckItems.isNotEmpty
                                      ? roadmapCheckItems[index]
                                      : null;

                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  bool isCurrentStage =
                                      roadmapCheckItems[index] == '현단계';
                                  setStateModal(() {
                                    selectedRoadmapIndex = index;
                                    selectedRoadmapText = roadmapList;
                                    widget.onSelectedRoadmapChanged(
                                        roadmapList, index, isCurrentStage);
                                  });
                                },
                                child: Container(
                                  height: 48,
                                  color: selectedRoadmapIndex == index
                                      ? AppColors.g1
                                      : AppColors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        if (roadmapCheck == '현단계')
                                          Text(
                                            roadmapList,
                                            style: AppTextStyles.bd1.copyWith(
                                                color: AppColors.blue),
                                          ),
                                        if (roadmapCheck == '도약완료' ||
                                            roadmapCheck == null)
                                          Text(
                                            roadmapList,
                                            style: AppTextStyles.bd2
                                                .copyWith(color: AppColors.g6),
                                          ),
                                        Gaps.h8,
                                        if (roadmapCheck == '현단계')
                                          Text(
                                            '· 현 단계',
                                            style: AppTextStyles.caption
                                                .copyWith(
                                                    color: AppColors.blue),
                                          ),
                                        if (roadmapCheck == '도약완료')
                                          Text('· 도약완료',
                                              style: AppTextStyles.caption),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            color: AppColors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 24,
                              right: 24,
                              top: 20,
                              bottom: 24,
                            ),
                            child: Container(
                              height: 48,
                              color: AppColors.bluebg,
                              child: Center(
                                child: Text(
                                  '현재 ${roadmapItems.length}단계 중 ${roadmapCheckItems.indexOf('현단계') + 1}단계를 도약했어요 :)',
                                  style: AppTextStyles.bd2
                                      .copyWith(color: AppColors.g5),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      );
    }

    return GestureDetector(
      onTap: () => roadMapTap(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            selectedRoadmapText ?? '', // 선택된 항목의 텍스트 또는 기본 텍스트 표시
            style: AppTextStyles.h5.copyWith(color: AppColors.white),
          ),
          Gaps.h6,
          Image(image: AppImages.roadmap_downarrow),
        ],
      ),
    );
  }
}
