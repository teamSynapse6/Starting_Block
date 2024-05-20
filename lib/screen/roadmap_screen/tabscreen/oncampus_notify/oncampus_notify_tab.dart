import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/roadmap_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';
import 'package:starting_block/screen/roadmap_screen/tabscreen/oncampus_notify/onca_notify_recommend.dart';

class TabScreenOnCaNotify extends StatefulWidget {
  final String thisSelectedText;
  final int thisSelectedId;

  final bool thisCurrentStage;

  const TabScreenOnCaNotify({
    super.key,
    required this.thisSelectedText,
    required this.thisCurrentStage,
    required this.thisSelectedId,
  });

  @override
  State<TabScreenOnCaNotify> createState() => _TabScreenOnCaNotifyState();
}

class _TabScreenOnCaNotifyState extends State<TabScreenOnCaNotify> {
  List<int> savedIds = [];
  List<RoadMapSavedOncaModel> onCampusNotifyData = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadOnCampusNotifyData();
  }

  @override
  void didUpdateWidget(TabScreenOnCaNotify oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.thisSelectedText != widget.thisSelectedText) {
      loadOnCampusNotifyData();
    }
  }

  void loadOnCampusNotifyData() async {
    List<RoadMapSavedOncaModel> loadedData =
        await RoadMapApi.getSavedListOncampus(
      roadmapId: widget.thisSelectedId,
    );
    setState(() {
      onCampusNotifyData = loadedData;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.secondaryBG,
        body: CustomScrollView(slivers: <Widget>[
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (ableText.contains(widget.thisSelectedText))
                  OnCaNotifyRecommend(
                    thisSelectedText: widget.thisSelectedText,
                    thisCurrentStage: widget.thisCurrentStage,
                    roadmapId: widget.thisSelectedId,
                  ),
                Gaps.v24,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('저장한 사업으로 도약하기',
                          style:
                              AppTextStyles.bd1.copyWith(color: AppColors.g6)),
                      Gaps.v16,
                    ],
                  ),
                ),
              ],
            ),
          ),
          _isLoading
              ? const RoadMapOfcaOncaTabSkeleton()
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final item = onCampusNotifyData[index];

                      return Container(
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          borderRadius:
                              BorderRadius.zero, // 조건부 BorderRadius 적용
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            OnCaListNotify(
                              thisProgramType: item.keyword,
                              thisID: item.announcementId.toString(),
                              thisTitle: item.title,
                              thisUrl: item.detailUrl,
                              thisStartDate: item.insertDate,
                              thisIsSaved: item.isBookmarked,
                            ),
                            if (index < onCampusNotifyData.length - 1)
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: CustomDivider(),
                              ),
                          ],
                        ),
                      );
                    },
                    childCount: onCampusNotifyData
                        .length, // 변경: OffCampusModel을 OnCampusNotifyModel로 변경
                  ),
                )
        ]));
  }
}
