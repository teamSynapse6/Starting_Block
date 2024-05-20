import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/roadmap_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';
import 'package:starting_block/screen/roadmap_screen/tabscreen/oncampus_system/onca_system_recommend.dart';

const List<String> validTextsSystem = globalDataRoadmapList;

class TabScreenOnCaSystem extends StatefulWidget {
  final String thisSelectedText;
  final int thisSelectedId;

  final bool thisCurrentStage;

  const TabScreenOnCaSystem({
    super.key,
    required this.thisSelectedText,
    required this.thisCurrentStage,
    required this.thisSelectedId,
  });

  @override
  State<TabScreenOnCaSystem> createState() => _TabScreenOnCaSystemState();
}

class _TabScreenOnCaSystemState extends State<TabScreenOnCaSystem> {
  List<int> savedIds = [];
  List<RoadMapSavedSystemModel> onCampusSystemData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadOnCampusSystemData();
  }

  @override
  void didUpdateWidget(TabScreenOnCaSystem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.thisSelectedText != widget.thisSelectedText) {
      loadOnCampusSystemData();
    }
  }

  void loadOnCampusSystemData() async {
    List<RoadMapSavedSystemModel> loadedData =
        await RoadMapApi.getSavedListSystem(
      roadmapId: widget.thisSelectedId,
    );
    setState(() {
      onCampusSystemData = loadedData;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookMarkNotifier>(
        builder: (context, bookMarkNotifier, child) {
      if (bookMarkNotifier.isUpdated) {
        loadOnCampusSystemData();
        bookMarkNotifier.resetUpdate();
      }

      return Scaffold(
        backgroundColor: AppColors.secondaryBG,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gaps.v24,
                  if (validTextsSystem.contains(widget.thisSelectedText))
                    OnCaSystemRecommend(
                      thisSelectedText: widget.thisSelectedText,
                      thisCurrentStage: widget.thisCurrentStage,
                      roadmapId: widget.thisSelectedId,
                    ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('저장한 사업으로 도약하기',
                            style: AppTextStyles.bd1
                                .copyWith(color: AppColors.g6)),
                        Gaps.v16,
                      ],
                    ),
                  ),
                ],
              ),
            ),
            isLoading
                ? const RoadMapSystemTabSkeleton()
                : onCampusSystemData.isNotEmpty
                    ? SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final item = onCampusSystemData[index];
                            return Column(
                              children: [
                                OnCaListSystem(
                                  thisTitle: item.title,
                                  thisId: item.announcementId.toString(),
                                  thisContent: item.content,
                                  thisTarget: item.target,
                                  isSaved: item.isBookmarked,
                                ),
                                Gaps.v16,
                              ],
                            );
                          },
                          childCount: onCampusSystemData.length,
                        ),
                      )
                    : SliverFillRemaining(
                        fillOverscroll: true,
                        hasScrollBody: false,
                        child: GotoSaveItem(
                          tapAction: () {
                            IntergrateScreen.setSelectedIndexToOne(context);
                          },
                        ),
                      ),
          ],
        ),
      );
    });
  }
}
