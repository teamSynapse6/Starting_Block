import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/roadmap_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';

class RoadMapList extends StatefulWidget {
  final Function(String)? selectedRoadMapTitle;
  final Function(int)? selectedRoadMapId;
  final Function(bool)? isCurrentStage;
  final Function(int)? selectedRoadMapStage;

  const RoadMapList({
    super.key,
    required this.selectedRoadMapTitle,
    required this.selectedRoadMapId,
    required this.isCurrentStage,
    required this.selectedRoadMapStage,
  });

  static void setSelectedRoadMapTitle(BuildContext context) {
    final state = context.findAncestorStateOfType<RoadMapListState>();
    state?.selectInProgressRoadMap();
  }

  static void reloadRoadMapStatus(BuildContext context) {
    final state = context.findAncestorStateOfType<RoadMapListState>();
    state?.loadRoadMaps();
  }

  @override
  State<RoadMapList> createState() => RoadMapListState();
}

class RoadMapListState extends State<RoadMapList> {
  List<RoadMapModel>? roadMaps;
  String selectedRoadMapTitle = ''; // 선택된 RoadMap의 제목을 저장할 변수
  int? selectedRoadMapId;
  bool? isCurrentStage;

  @override
  void initState() {
    super.initState();
    loadRoadMaps();
  }

  void loadRoadMaps() async {
    final roadMapList = await RoadMapApi.getRoadMapList();
    roadMapList
        .sort((a, b) => a.sequence.compareTo(b.sequence)); // sequence에 따라 정렬
    if (mounted) {
      setState(() {
        roadMaps = roadMapList;
        // IN_PROGRESS 상태인 항목을 기본 선택하거나, 없으면 마지막 항목 선택
        final inProgressOrLastRoadMap = roadMaps?.firstWhere(
          (roadMap) => roadMap.roadmapStatus == "IN_PROGRESS",
          orElse: () => roadMaps!.last,
        );
        if (inProgressOrLastRoadMap != null) {
          selectedRoadMapTitle = inProgressOrLastRoadMap.title;
          selectedRoadMapId = inProgressOrLastRoadMap.roadmapId;
          isCurrentStage =
              inProgressOrLastRoadMap.roadmapStatus == "IN_PROGRESS";

          widget.selectedRoadMapTitle?.call(inProgressOrLastRoadMap.title);
          widget.selectedRoadMapId?.call(inProgressOrLastRoadMap.roadmapId);
          widget.isCurrentStage
              ?.call(inProgressOrLastRoadMap.roadmapStatus == "IN_PROGRESS");
          widget.selectedRoadMapStage
              ?.call(inProgressOrLastRoadMap.sequence); //선택된 로드맵의 순서
        }
      });
    }
  }

  void selectInProgressRoadMap() {
    final inProgressRoadMap = roadMaps?.firstWhere(
      (roadMap) => roadMap.roadmapStatus == "IN_PROGRESS",
      orElse: () => roadMaps!.last,
    );

    if (inProgressRoadMap != null) {
      setState(() {
        selectedRoadMapTitle = inProgressRoadMap.title;
        selectedRoadMapId = inProgressRoadMap.roadmapId;
        isCurrentStage = inProgressRoadMap.roadmapStatus == "IN_PROGRESS";

        widget.selectedRoadMapTitle?.call(inProgressRoadMap.title);
        widget.selectedRoadMapId?.call(inProgressRoadMap.roadmapId);
        widget.isCurrentStage
            ?.call(inProgressRoadMap.roadmapStatus == "IN_PROGRESS");
        widget.selectedRoadMapStage
            ?.call(inProgressRoadMap.sequence); //선택된 로드맵의 순서
      });
    }
  }

  void roadMapTap(BuildContext context) async {
    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Stack(
              children: [
                Container(
                  height: 600,
                  color: AppColors.white,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Gaps.v18,
                      Row(
                        children: [
                          const Spacer(),
                          Material(
                            color: Colors.transparent,
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () async {
                                Navigator.pop(context);
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const RoadMapEdit()),
                                );
                                loadRoadMaps();
                              },
                              child: SizedBox(
                                height: 32,
                                width: 54,
                                child: Center(
                                  child: Text(
                                    '단계 편집',
                                    style: AppTextStyles.btn1
                                        .copyWith(color: AppColors.g6),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Gaps.h24,
                        ],
                      ),
                      Gaps.v6,
                      roadMaps == null
                          ? Container()
                          : Expanded(
                              child: ListView.builder(
                                itemCount: roadMaps!.length,
                                itemBuilder: (context, index) {
                                  final roadMap = roadMaps![index];
                                  final isSelected = roadMap.roadmapId ==
                                      selectedRoadMapId; // 선택된 항목인지 확인
                                  return Material(
                                    color: Colors.transparent,
                                    child: Ink(
                                      height: 48,
                                      color: isSelected
                                          ? AppColors.g1
                                          : AppColors.white,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            selectedRoadMapTitle =
                                                roadMap.title;
                                            selectedRoadMapId = roadMap
                                                .roadmapId; // 선택한 항목의 ID를 업데이트
                                          });

                                          widget.selectedRoadMapTitle
                                              ?.call(roadMap.title);
                                          widget.selectedRoadMapId
                                              ?.call(roadMap.roadmapId);
                                          widget.isCurrentStage?.call(
                                              roadMap.roadmapStatus ==
                                                  "IN_PROGRESS");
                                          widget.selectedRoadMapStage
                                              ?.call(roadMap.sequence);

                                          Navigator.pop(context); // 바텀 시트 닫기
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 24),
                                          child: Row(
                                            children: [
                                              Text(
                                                roadMap.title,
                                                style: roadMap.roadmapStatus ==
                                                        "COMPLETED"
                                                    ? AppTextStyles.bd2
                                                        .copyWith(
                                                            color: AppColors.g4)
                                                    : roadMap.roadmapStatus ==
                                                            "IN_PROGRESS"
                                                        ? AppTextStyles.bd1
                                                            .copyWith(
                                                                color: AppColors
                                                                    .blue)
                                                        : AppTextStyles.bd2
                                                            .copyWith(
                                                                color: AppColors
                                                                    .g6),
                                              ),
                                              Gaps.h8,
                                              if (roadMap.roadmapStatus ==
                                                  "COMPLETED")
                                                Text(
                                                  "· 도약 완료",
                                                  style: AppTextStyles.caption
                                                      .copyWith(
                                                          color: AppColors.g4),
                                                )
                                              else if (roadMap.roadmapStatus ==
                                                  "IN_PROGRESS")
                                                Text(
                                                  "· 현 단계",
                                                  style: AppTextStyles.caption
                                                      .copyWith(
                                                          color:
                                                              AppColors.blue),
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(24, 6, 24, 24),
                        decoration: const BoxDecoration(color: AppColors.white),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(24, 14, 24, 12),
                          decoration: BoxDecoration(
                            color: AppColors.bluebg,
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "현재 ${roadMaps!.length}단계 중 ",
                                style: AppTextStyles.bd2
                                    .copyWith(color: AppColors.g5),
                              ),
                              Text(
                                "${roadMaps!.indexWhere((roadMap) => roadMap.roadmapStatus == "IN_PROGRESS") + 1}단계를 ",
                                style: AppTextStyles.bd1
                                    .copyWith(color: AppColors.g6),
                              ),
                              Text(
                                "도약했어요 :)",
                                style: AppTextStyles.bd2
                                    .copyWith(color: AppColors.g5),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Positioned(
                  left: 0,
                  right: 0,
                  bottom: 78,
                  child: Column(
                    children: [
                      BottomGradient(),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => roadMapTap(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            selectedRoadMapTitle.isEmpty ? '' : selectedRoadMapTitle,
            style: AppTextStyles.st2.copyWith(color: AppColors.white),
          ),
          Gaps.h6,
          AppIcon.roadmap_downarrow,
        ],
      ),
    );
  }
}
