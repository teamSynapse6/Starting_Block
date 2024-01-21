import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starting_block/constants/constants.dart';
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
        state: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gaps.v22,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
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
                  children: <Widget>[
                    for (int index = 0;
                        index < _tempRoadmapList.length;
                        index++)
                      IgnorePointer(
                        ignoring: _tempRoadmapListCheck[index] == '도약완료',
                        key: ValueKey(_tempRoadmapList[index]),
                        child: SizedBox(
                          height: 48,
                          child: ListTile(
                            titleAlignment: ListTileTitleAlignment.center,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 24),
                            title: Text(
                              _tempRoadmapList[index],
                              style: AppTextStyles.bd2
                                  .copyWith(color: AppColors.g6),
                            ),
                            trailing: Image(image: AppImages.sort_actived),
                          ),
                        ),
                      ),
                  ],
                  onReorder: (int oldIndex, int newIndex) {
                    if (_tempRoadmapListCheck[oldIndex] == '도약완료') {
                      return;
                    }

                    // 현단계 이후의 null 상태 항목들만 순서 변경 가능하게 합니다.
                    int currentStageIndex =
                        _tempRoadmapListCheck.indexOf('현단계');
                    if (currentStageIndex != -1) {
                      if (oldIndex < currentStageIndex ||
                          newIndex <= currentStageIndex) {
                        return;
                      }
                      int lastNullIndex =
                          _tempRoadmapListCheck.lastIndexOf(null);
                      if (newIndex > lastNullIndex + 1) {
                        return;
                      }
                    }

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
