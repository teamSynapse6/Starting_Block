import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/intergrate_screen.dart';
import 'package:starting_block/manage/api/roadmap_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/screen/roadmap_screen/roadmap_delet.dart';
import 'package:starting_block/screen/roadmap_screen/roadmaplist_add.dart';

class RoadMapEdit extends StatefulWidget {
  const RoadMapEdit({super.key});

  @override
  State<RoadMapEdit> createState() => _RoadMapEditState();
}

class _RoadMapEditState extends State<RoadMapEdit> {
  List<RoadMapModel>? roadMaps;
  int? draggingIndex;
  bool _isDeactived = true; // 순서 변경 확인을 위한 플래그 추가

  @override
  void initState() {
    super.initState();
    loadRoadMaps();
  }

  void loadRoadMaps() async {
    final roadMapList = await RoadMapApi.getRoadMapList();
    roadMapList
        .sort((a, b) => a.sequence.compareTo(b.sequence)); // sequence에 따라 정렬
    setState(() {
      roadMaps = roadMapList;
    });
  }

  void onReorder(int oldIndex, int newIndex) {
    // 'COMPLETED' 상태의 마지막 인덱스를 찾습니다.
    int lastCompletedIndex = roadMaps!
        .lastIndexWhere((roadMap) => roadMap.roadmapStatus == "COMPLETED");

    // newIndex가 oldIndex보다 큰 경우, newIndex를 조정합니다.
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }

    // 드래그하려는 아이템이 'COMPLETED' 상태인 항목 뒤에 있거나,
    // 새 위치(newIndex)가 'COMPLETED' 상태의 마지막 인덱스보다 앞에 있을 경우,
    // 재정렬을 허용하지 않습니다.
    if (oldIndex <= lastCompletedIndex || newIndex <= lastCompletedIndex) {
      return; // 변경 사항을 적용하지 않고 함수 종료
    }

    // 재정렬 로직을 실행합니다.
    setState(() {
      final RoadMapModel item = roadMaps!.removeAt(oldIndex);
      roadMaps!.insert(newIndex, item);
      _isDeactived = false;
    });
  }

  // '완료' 버튼을 눌렀을 때 실행되는 메소드
  void _onCompleteTap() async {
    if (_isDeactived) {
      return;
    }
    List<int> roadmapIds =
        roadMaps!.map((roadMap) => roadMap.roadmapId).toList();
    await RoadMapApi.roadMapReorder(roadmapIds);
    setState(() {
      _isDeactived = true;
    });
    if (mounted) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => const IntergrateScreen(
                    switchIndex: SwitchIndex.toThree,
                  )),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const IntergrateScreen(
                            switchIndex: SwitchIndex.toThree,
                          )),
                  (route) => false);
            },
            child: AppIcon.back,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gaps.v20,
          Padding(
            padding: const EdgeInsets.only(
              left: 24,
              right: 12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '로드맵 단계 수정',
                  style: AppTextStyles.h5.copyWith(color: AppColors.black),
                ),
                Gaps.v10,
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RoadMapAdd()),
                        ).then((result) {
                          loadRoadMaps();
                        });
                      },
                      child: SizedBox(
                        height: 32,
                        width: 50,
                        child: Center(
                          child: Text(
                            '추가',
                            style: AppTextStyles.btn1
                                .copyWith(color: AppColors.g6),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RoadMapDelete()),
                        ).then((result) {
                          loadRoadMaps();
                        });
                      },
                      child: SizedBox(
                        height: 32,
                        width: 50,
                        child: Center(
                          child: Text(
                            '삭제',
                            style: AppTextStyles.btn1
                                .copyWith(color: AppColors.g6),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: roadMaps != null
                ? ReorderableListView.builder(
                    itemCount: roadMaps!.length,
                    itemBuilder: (context, index) {
                      final roadMap = roadMaps![index];
                      return IgnorePointer(
                        ignoring: roadMap.roadmapStatus == "COMPLETED",
                        key: ValueKey(roadMap.roadmapId),
                        child: ReorderCustomTile(
                          thisText: roadMap.title,
                          thisTextStyle:
                              AppTextStyles.bd2.copyWith(color: AppColors.g6),
                          isComlete: roadMap.roadmapStatus == "COMPLETED",
                        ),
                      );
                    },
                    onReorderStart: (int newIndex) {
                      setState(() {
                        draggingIndex = newIndex;
                      });
                    },
                    onReorderEnd: (int oldIndex) {
                      setState(() {
                        draggingIndex = -1;
                      });
                    },
                    onReorder: onReorder,
                    proxyDecorator:
                        (Widget child, int index, Animation<double> animation) {
                      return AnimatedBuilder(
                        animation: animation,
                        builder: (context, child) {
                          double elevation = Tween<double>(begin: 0.0, end: 6.0)
                              .evaluate(animation);
                          if (index == draggingIndex) {
                            return Material(
                              color: AppColors.white,
                              elevation: elevation,
                              child: ReorderCustomTile(
                                thisText: roadMaps![index].title,
                                thisTextStyle: AppTextStyles.bd1
                                    .copyWith(color: AppColors.g6),
                              ),
                            );
                          }
                          return Material(
                            elevation: 0.0,
                            child: child,
                          );
                        },
                        child: child,
                      );
                    },
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: InkWell(
              onTap: _onCompleteTap,
              child: NextContained(
                disabled: _isDeactived,
                text: '완료',
              ),
            ),
          )
        ],
      ),
    );
  }
}
