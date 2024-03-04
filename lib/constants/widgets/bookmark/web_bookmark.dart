import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/constants/widgets/bookmark/bookmark_list.dart';
import 'package:starting_block/screen/manage/models/roadmap_model.dart';

class WebBookMarkButton extends StatefulWidget {
  final String id;
  final String classification;

  const WebBookMarkButton({
    super.key,
    required this.id,
    required this.classification,
  });

  @override
  State<WebBookMarkButton> createState() => _WebBookMarkButtonState();
}

class _WebBookMarkButtonState extends State<WebBookMarkButton> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _bookMarkTap(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Consumer<RoadMapModel>(
          // Consumer 사용
          builder: (context, roadmapModel, child) {
            final List<String> roadmapList = roadmapModel.roadmapList;

            return Container(
              color: AppColors.white,
              height: 400,
              width: MediaQuery.of(context).size.width,
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
                  Expanded(
                    child: ListView.builder(
                      key: const PageStorageKey<String>(
                          'bookmarkList'), // Key 추가
                      controller: _scrollController,
                      itemCount: roadmapList.length,
                      itemBuilder: (context, index) {
                        return FutureBuilder<bool>(
                          future: roadmapModel.isItemSaved(widget.id,
                              widget.classification, roadmapList[index]),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Container();
                            }

                            bool isSaved = snapshot.data ?? false;
                            return BookMarkList(
                              thisText: roadmapList[index],
                              thisColor: AppColors.white,
                              thisIcon: isSaved
                                  ? AppIcon.plus_actived
                                  : AppIcon.plus_inactived,
                              thisTapAction: () {
                                if (isSaved) {
                                  roadmapModel.removeSavedItem(
                                      widget.id,
                                      widget.classification,
                                      roadmapList[index]);
                                } else {
                                  roadmapModel.saveRoadmapItem(
                                      widget.id,
                                      widget.classification,
                                      roadmapList[index]);
                                }
                              },
                            );
                          },
                        );
                      },
                    ),
                  )
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
        width: MediaQuery.of(context).size.width * (232 / 360),
        height: 48,
        child: FractionallySizedBox(
          widthFactor: 1,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.blue,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Text(
                '로드맵에 저장하기',
                style: AppTextStyles.btn1.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
