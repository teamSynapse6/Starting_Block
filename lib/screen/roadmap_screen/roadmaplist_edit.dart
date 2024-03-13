import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/model_manage.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';

class RoadMapEdit extends StatefulWidget {
  const RoadMapEdit({super.key});

  @override
  RoadMapEditState createState() => RoadMapEditState();
}

class RoadMapEditState extends State<RoadMapEdit> {
  bool _isOrderChanged = false;
  late List<String> _tempRoadmapList; // 임시 로드맵 순서
  late List<String?> _tempRoadmapListCheck; // 임시 체크 상태
  int? draggingIndex = -1;

  @override
  void initState() {
    super.initState();
    final roadmapModel = Provider.of<RoadMapModel>(context, listen: false);
    _tempRoadmapList = List<String>.from(roadmapModel.roadmapList);
    _tempRoadmapListCheck = List<String?>.from(roadmapModel.roadmapListCheck);
  }

  void _updateRoadmapOrder() {
    // RoadMapModel 인스턴스를 가져옵니다.
    final roadmapModel = Provider.of<RoadMapModel>(context, listen: false);
    // 모델을 업데이트합니다.
    roadmapModel.reorderRoadmapList(_tempRoadmapList, _tempRoadmapListCheck);
  }

  void _reloadRoadmapModel() {
    setState(() {
      final roadmapModel = Provider.of<RoadMapModel>(context, listen: false);
      _tempRoadmapList = List<String>.from(roadmapModel.roadmapList);
      _tempRoadmapListCheck = List<String?>.from(roadmapModel.roadmapListCheck);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BackAppBar(
        state: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gaps.v22,
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
                    GestureDetector(
                      onTap: () async {
                        bool result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RoadMapAdd()),
                        );
                        if (result) {
                          _reloadRoadmapModel();
                        }
                      },
                      child: SizedBox(
                        height: 32,
                        width: 49,
                        child: Center(
                          child: Text(
                            '추가',
                            style: AppTextStyles.btn1
                                .copyWith(color: AppColors.g6),
                          ),
                        ),
                      ),
                    ),
                    Gaps.h4,
                    GestureDetector(
                      onTap: () async {
                        bool result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RoadMapDelete()),
                        );
                        if (result) {
                          _reloadRoadmapModel();
                        }
                      },
                      child: SizedBox(
                        height: 32,
                        width: 49,
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
            child: Consumer<RoadMapModel>(
              builder: (context, roadmapModel, child) {
                return ReorderableListView(
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
                  proxyDecorator:
                      (Widget child, int index, Animation<double> animation) {
                    return AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) {
                        // 애니메이션 값에 따라 elevation을 계산합니다.
                        double elevation = Tween<double>(begin: 0.0, end: 6.0)
                            .evaluate(animation);
                        // 드래그 중인 아이템에 대한 스타일을 적용합니다.
                        if (index == draggingIndex) {
                          return Material(
                            elevation: elevation,
                            child: ReorderCustomTile(
                              thisText: _tempRoadmapList[index],
                              thisTextStyle: AppTextStyles.bd1
                                  .copyWith(color: AppColors.g6),
                              isComlete: _tempRoadmapListCheck[index] == '도약완료',
                            ),
                          );
                        }
                        return Material(
                          elevation: 0.0, // 드래그 중이 아닌 아이템은 기본 elevation을 적용합니다.
                          child: child,
                        );
                      },
                      child: child,
                    );
                  },
                  onReorder: (int oldIndex, int newIndex) {
                    // '도약완료' 상태의 마지막 인덱스를 찾습니다.
                    int lastCompletedIndex =
                        _tempRoadmapListCheck.lastIndexOf('도약완료');
                    // 드래그하려는 아이템이 '도약완료' 인덱스 이하인 경우 드래그를 허용하지 않습니다.
                    if (oldIndex <= lastCompletedIndex) return;
                    // 드래그를 끝내는 위치가 '도약완료' 상태의 마지막 인덱스 이하인 경우 드래그를 허용하지 않습니다.
                    if (newIndex <= lastCompletedIndex) return;
                    setState(() {
                      _isOrderChanged = true;
                      if (newIndex > oldIndex) {
                        newIndex -= 1;
                      }
                      final item = _tempRoadmapList.removeAt(oldIndex);
                      final checkItem =
                          _tempRoadmapListCheck.removeAt(oldIndex);
                      _tempRoadmapList.insert(newIndex, item);
                      _tempRoadmapListCheck.insert(newIndex, checkItem);
                    });
                  },
                  children: <Widget>[
                    for (int index = 0;
                        index < _tempRoadmapList.length;
                        index++)
                      IgnorePointer(
                        ignoring: _tempRoadmapListCheck[index] == '도약완료',
                        key: ValueKey(_tempRoadmapList[index]),
                        child: ReorderCustomTile(
                          thisText: _tempRoadmapList[index],
                          key: ValueKey(_tempRoadmapList[index]),
                          thisTextStyle: (_tempRoadmapListCheck[index] == '도약완료'
                              ? AppTextStyles.bd2.copyWith(color: AppColors.g4)
                              : AppTextStyles.bd2
                                  .copyWith(color: AppColors.g6)),
                          isComlete: _tempRoadmapListCheck[index] == '도약완료',
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              right: 24,
              left: 24,
              bottom: 24,
            ),
            child: GestureDetector(
              onTap: _isOrderChanged
                  ? () {
                      _updateRoadmapOrder();
                      Navigator.pop(context, true);
                    }
                  : null,
              child: NextContained(
                text: "완료",
                disabled: !_isOrderChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
