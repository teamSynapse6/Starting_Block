import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';

class RoadMapList extends StatefulWidget {
  const RoadMapList({super.key});

  @override
  State<RoadMapList> createState() => _RoadMapListState();
}

class _RoadMapListState extends State<RoadMapList> {
  int? selectedRoadmapIndex;
  String? selectedRoadmapText;

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
    final roadmapItems = Provider.of<RoadMapModel>(context).roadmapList;

    if (selectedRoadmapText == null && roadmapItems.isNotEmpty) {
      selectedRoadmapText = roadmapItems[0];
    }

    void roadMapTap(BuildContext context) async {
      await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
          return Consumer<RoadMapModel>(
            builder: (context, roadmapModel, child) {
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setStateModal) {
                  final roadmapItems = roadmapModel.roadmapList;
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
                              return GestureDetector(
                                behavior: HitTestBehavior.opaque,
                                onTap: () {
                                  setStateModal(() {
                                    selectedRoadmapIndex = index;
                                  });
                                  setState(() {
                                    selectedRoadmapText = roadmapItems[index];
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
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        roadmapList,
                                        style: AppTextStyles.bd2
                                            .copyWith(color: AppColors.g6),
                                      ),
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
                                  '현재 ${roadmapItems.length}단계 중 1단계를 도약했어요 :)',
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
