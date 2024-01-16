import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';

class RoadMapList extends StatefulWidget {
  final Function(String) onSelectedRoadmapChanged;

  const RoadMapList({
    super.key,
    required this.onSelectedRoadmapChanged,
  });

  @override
  State<RoadMapList> createState() => _RoadMapListState();
}

class _RoadMapListState extends State<RoadMapList> {
  int? selectedRoadmapIndex;
  String? selectedRoadmapText;

  // Getter를 추가하여 외부에서 선택된 텍스트에 접근할 수 있게 함
  String? getSelectedRoadmapText() {
    return selectedRoadmapText;
  }

  void _onEditTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RoadMapEdit(),
      ),
    ).then((_) {
      // RoadMapEdit에서 돌아온 후 상태를 갱신합니다.
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final roadmapModel = Provider.of<RoadMapModel>(context);
    final roadmapItems = roadmapModel.roadmapList;
    final roadmapCheckItems = roadmapModel.roadmapListCheck;

    // 첫 번째 항목이 '현 단계'인 경우를 기본값으로 설정
    if (selectedRoadmapText == null && roadmapItems.isNotEmpty) {
      selectedRoadmapText = roadmapItems[0];
      if (roadmapCheckItems.isEmpty) {
        roadmapCheckItems[0] = '현단계';
      }
    }

    // '현 단계'의 인덱스 찾기
    int currentStepIndex =
        roadmapCheckItems.indexOf('현단계') + 1; // 인덱스가 0부터 시작하므로 +1

    void roadMapTap(BuildContext context) async {
      await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return Consumer<RoadMapModel>(
            builder: (context, roadmapModel, child) {
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
                                  setStateModal(() {
                                    selectedRoadmapIndex = index;
                                  });
                                  setState(() {
                                    selectedRoadmapText = roadmapItems[index];
                                    widget.onSelectedRoadmapChanged(
                                        selectedRoadmapText!);
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
                                  '현재 ${roadmapItems.length}단계 중 $currentStepIndex단계를 도약했어요 :)',
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
