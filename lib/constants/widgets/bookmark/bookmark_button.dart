// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/constants/widgets/bookmark/bookmark_list.dart';
import 'package:starting_block/screen/manage/api/roadmap_api_manage.dart';
import 'package:starting_block/screen/manage/model_manage.dart';

class BookMarkButton extends StatefulWidget {
  final bool isSaved;
  final String thisID;

  const BookMarkButton({
    super.key,
    required this.isSaved,
    required this.thisID,
  });

  @override
  State<BookMarkButton> createState() => _BookMarkButtonState();
}

class _BookMarkButtonState extends State<BookMarkButton> {
  List<RoadMapAnnounceModel>? roadMaps;

  @override
  void initState() {
    super.initState();
    loadRoadMaps();
  }

  void loadRoadMaps() async {
    // widget.thisID를 통해 announcementId를 받아오고, API를 호출합니다.
    final roadMapAnnounceList =
        await RoadMapApi.getRoadMapAnnounceList(widget.thisID);
    // 받아온 데이터로 상태를 업데이트합니다.
    setState(() {
      roadMaps = roadMapAnnounceList;
    });
  }

  void _saveAction(int roadmapId) async {
    try {
      await RoadMapApi.addAnnouncementToRoadMap(roadmapId, widget.thisID);
      // 성공적으로 추가된 후의 로직, 예를 들어 상태 업데이트나 사용자에게 알림
      print('공고가 성공적으로 추가되었습니다.');
    } catch (e) {
      print('공고 추가에 실패했습니다: $e');
      // 실패 시 사용자에게 알림을 제공할 수 있습니다.
    }
  }

  void _deleteAction(int roadmapId) async {
    try {
      await RoadMapApi.deleteAnnouncementFromRoadMap(roadmapId, widget.thisID);
      // 성공적으로 삭제된 후의 로직, 예를 들어 상태 업데이트나 사용자에게 알림
      print('공고가 성공적으로 삭제되었습니다.');
    } catch (e) {
      print('공고 삭제에 실패했습니다: $e');
      // 실패 시 사용자에게 알림을 제공할 수 있습니다.
    }
  }

  void _updateRoadMapsModal(StateSetter setStateModal) async {
    final roadMapAnnounceList =
        await RoadMapApi.getRoadMapAnnounceList(widget.thisID);
    setStateModal(() {
      roadMaps = roadMapAnnounceList;
    });
  }

  void _bookMarkTap(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        // StatefulBuilder를 사용하여 상태를 관리합니다.
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateModal) {
            // 여기서 setStateModal은 모달 내부에서 사용할 수 있는 setState 함수입니다.
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
                  roadMaps == null
                      ? const CircularProgressIndicator()
                      : Expanded(
                          child: ListView.builder(
                            itemCount: roadMaps!.length,
                            itemBuilder: (context, index) {
                              final roadMap = roadMaps![index];
                              return BookMarkList(
                                thisText: roadMap.title,
                                thisColor: AppColors.white,
                                thisTapAction: () async {
                                  if (roadMap.isAnnouncementSaved) {
                                    _deleteAction(roadMap.roadmapId);
                                  } else {
                                    _saveAction(roadMap.roadmapId);
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
