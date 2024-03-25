import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/constants/widgets/bookmark/bookmark_list.dart';
import 'package:starting_block/screen/manage/api/roadmap_api_manage.dart';
import 'package:starting_block/screen/manage/model_manage.dart';

class BookMarkButton extends StatefulWidget {
  final bool isSaved;

  const BookMarkButton({
    super.key,
    required this.isSaved,
  });

  @override
  State<BookMarkButton> createState() => _BookMarkButtonState();
}

class _BookMarkButtonState extends State<BookMarkButton> {
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

  void _SaveAction() {}

  void _bookMarkTap(BuildContext context) async {
    await showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
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
                                thisTapAction: _SaveAction,
                                thisIcon: AppIcon.plus_inactived,
                              );
                            }),
                      )
              ],
            ),
          );
        });
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
