import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  List<RoadMapOnCampusRecModel> _onCampusRecData = []; // 로드된 데이터를 저장할 리스트
  bool _isLoading = true;
  bool _isRecLoading = true;

  @override
  void initState() {
    super.initState();
    loadOnCampusNotifyData();
    loadOnCaNotifyRec();
  }

  @override
  void didUpdateWidget(TabScreenOnCaNotify oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.thisSelectedText != widget.thisSelectedText) {
      loadOnCampusNotifyData();
      loadOnCaNotifyRec();
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

  Future<void> loadOnCaNotifyRec() async {
    final onCampusRecData =
        await RoadMapApi.getOnCampusRec(widget.thisSelectedId);
    setState(() {
      _onCampusRecData = onCampusRecData;
      _isRecLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookMarkNotifier>(
        builder: (context, bookMarkNotifier, child) {
      if (bookMarkNotifier.isUpdated) {
        loadOnCampusNotifyData();
        loadOnCaNotifyRec();
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
                  if (globalDataRoadmapList.contains(widget.thisSelectedText))
                    OnCaNotifyRecommend(
                      thisSelectedText: widget.thisSelectedText,
                      thisCurrentStage: widget.thisCurrentStage,
                      roadmapId: widget.thisSelectedId,
                      thisOnCampusRecData: _onCampusRecData,
                      thisRecLoading: _isRecLoading,
                    ),
                  Gaps.v24,
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
            _isLoading
                ? const RoadMapOfcaOncaTabSkeleton()
                : onCampusNotifyData.isNotEmpty
                    ? SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final item = onCampusNotifyData[index];
                            return Container(
                              decoration: const BoxDecoration(
                                color: AppColors.white,
                                borderRadius:
                                    BorderRadius.zero, // 조건부 BorderRadius 적용
                              ),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 24),
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
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
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
