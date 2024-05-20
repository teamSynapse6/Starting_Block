// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/constants/widgets/bookmark/bookmark_list.dart';
import 'package:starting_block/manage/api/roadmap_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';

class BookMarkLectureButton extends StatefulWidget {
  final bool isSaved;
  final String thisLectureID;

  const BookMarkLectureButton({
    super.key,
    required this.isSaved,
    required this.thisLectureID,
  });

  @override
  State<BookMarkLectureButton> createState() => _BookMarkLectureButtonState();
}

class _BookMarkLectureButtonState extends State<BookMarkLectureButton> {
  List<RoadMapAnnounceModel>? roadMaps;

  @override
  void initState() {
    super.initState();
    loadRoadMaps();
  }

  void loadRoadMaps() async {
    // widget.thisLectureID를 통해 announcementId를 받아오고, API를 호출합니다.
    final roadMapAnnounceList =
        await RoadMapApi.getRoadMapLectureList(widget.thisLectureID);

    // 받아온 데이터로 상태를 업데이트합니다.
    setState(() {
      roadMaps = roadMapAnnounceList;
    });
  }

  void _saveAction(int roadmapId, StateSetter setStateModal) async {
    try {
      await RoadMapApi.addLectureToRoadMap(roadmapId, widget.thisLectureID);
      // 성공적으로 추가된 후의 로직, 예를 들어 상태 업데이트나 사용자에게 알림
      print('공고가 성공적으로 추가되었습니다.');
      _updateRoadMapsModal(setStateModal);
      if (mounted) {
        Provider.of<BookMarkNotifier>(context, listen: false).updateBookmark();
        Navigator.pop(context);
      }
    } catch (e) {
      print('공고 추가에 실패했습니다: $e');
      // 실패 시 사용자에게 알림을 제공할 수 있습니다.
    }
  }

  void _deleteAction(int roadmapId, StateSetter setStateModal) async {
    try {
      await RoadMapApi.deleteLectureFromRoadMap(
          roadmapId, widget.thisLectureID);
      // 성공적으로 삭제된 후의 로직, 예를 들어 상태 업데이트나 사용자에게 알림
      print('공고가 성공적으로 삭제되었습니다.');
      _updateRoadMapsModal(setStateModal);
      if (mounted) {
        Provider.of<BookMarkNotifier>(context, listen: false).updateBookmark();
        Navigator.pop(context);
      }
    } catch (e) {
      print('공고 삭제에 실패했습니다: $e');
      // 실패 시 사용자에게 알림을 제공할 수 있습니다.
    }
  }

  void _updateRoadMapsModal(StateSetter setStateModal) async {
    final roadMapAnnounceList =
        await RoadMapApi.getRoadMapLectureList(widget.thisLectureID);
    setStateModal(() {
      roadMaps = roadMapAnnounceList;
    });
  }

  void gotoSaveRoadmapTap() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const IntergrateScreen(
          switchIndex: SwitchIndex.toThree,
        ),
      ),
      (route) => false,
    );
  }

  void _bookMarkTap(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateModal) {
            return Container(
              height: 400,
              width: MediaQuery.of(context).size.width,
              color: AppColors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gaps.v24,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      '로드맵에 저장하기',
                      style: AppTextStyles.st2.copyWith(color: AppColors.g6),
                    ),
                  ),
                  Gaps.v8,
                  // 조건을 검사하여 저장된 로드맵이 없는 경우 메시지를 표시합니다.
                  if (roadMaps == null || roadMaps!.isEmpty)
                    Center(
                      child: Column(
                        children: [
                          Gaps.v104,
                          Text(
                            '저장된 로드맵이 없습니다.\n로드맵을 설정해볼까요?',
                            style:
                                AppTextStyles.bd2.copyWith(color: AppColors.g6),
                            textAlign: TextAlign.center,
                          ),
                          Gaps.v24,
                          GotoSaveRoadmap(
                            tapAction: gotoSaveRoadmapTap,
                          ),
                        ],
                      ),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: roadMaps!.length,
                        itemBuilder: (context, index) {
                          final roadMap = roadMaps![index];
                          return BookMarkList(
                            thisText: roadMap.title,
                            thisColor: AppColors.white,
                            thisTapAction: () async {
                              print('클릭이 되었습니다.');
                              if (roadMap.isAnnouncementSaved) {
                                _deleteAction(roadMap.roadmapId, setStateModal);
                              } else {
                                _saveAction(roadMap.roadmapId, setStateModal);
                              }
                              // 모달의 상태를 업데이트합니다.
                              _updateRoadMapsModal(setStateModal);
                            },
                            thisIcon: roadMap.isAnnouncementSaved
                                ? AppIcon.plus_actived
                                : AppIcon.plus_inactived,
                          );
                        },
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _bookMarkTap(context),
      child: SizedBox(
          height: 24,
          width: 24,
          child: widget.isSaved
              ? AppIcon.bookmark_actived
              : AppIcon.bookmark_inactived),
    );
  }
}
