import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/intergrate_screen.dart';
import 'package:starting_block/screen/manage/api/roadmap_api_manage.dart';
import 'package:starting_block/screen/manage/model_manage.dart';
import 'package:starting_block/screen/roadmap_screen/roadmap_delet.dart';
import 'package:starting_block/screen/roadmap_screen/roadmaplist_add.dart';

class RoadMapEdit extends StatefulWidget {
  const RoadMapEdit({super.key});

  @override
  State<RoadMapEdit> createState() => _RoadMapEditState();
}

class _RoadMapEditState extends State<RoadMapEdit> {
  List<RoadMapModel>? roadMaps;

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
    setState(() {
      final RoadMapModel item = roadMaps!.removeAt(oldIndex);
      roadMaps!.insert(newIndex > oldIndex ? newIndex - 1 : newIndex, item);
    });
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
                      return ReorderCustomTile(
                        key: ValueKey(roadMap.roadmapId),
                        thisText: roadMap.title,
                        thisTextStyle:
                            AppTextStyles.bd2.copyWith(color: AppColors.g6),
                        isComlete: roadMap.roadmapStatus == "COMPLETED",
                      );
                    },
                    onReorder: onReorder,
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
        ],
      ),
    );
  }
}
