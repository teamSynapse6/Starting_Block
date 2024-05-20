import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/roadmap_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';
import 'package:starting_block/screen/roadmap_screen/tabscreen/offcampus_biz/ofca_recommend.dart';

class TabScreenOfCaBiz extends StatefulWidget {
  final String thisSelectedText;
  final int thisSelectedId;
  final bool thisCurrentStage;

  const TabScreenOfCaBiz({
    super.key,
    required this.thisSelectedText,
    required this.thisCurrentStage,
    required this.thisSelectedId,
  });

  @override
  State<TabScreenOfCaBiz> createState() => _TabScreenOfCaBizState();
}

class _TabScreenOfCaBizState extends State<TabScreenOfCaBiz> {
  List<RoadMapSavedOffcampusModel> offCampusData = [];
  List<RoadMapOffCampusRecModel> _offCampusRecData = [];
  bool _isLoading = true;
  bool _isRecLoading = true;

  @override
  void initState() {
    super.initState();
    loadOffCampusData();
    _loadOffCampusRecData();
  }

  @override
  void didUpdateWidget(TabScreenOfCaBiz oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.thisSelectedText != widget.thisSelectedText) {
      loadOffCampusData();
      _loadOffCampusRecData();
    }
  }

  void loadOffCampusData() async {
    var loadedData = await RoadMapApi.getSavedListOffcampus(
      roadmapId: widget.thisSelectedId,
    );
    setState(() {
      offCampusData = loadedData;
      _isLoading = false;
    });
  }

  void _loadOffCampusRecData() async {
    final offCampusRecData =
        await RoadMapApi.getOffCampusRec(widget.thisSelectedId);

    setState(() {
      _offCampusRecData = offCampusRecData;
      _isRecLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookMarkNotifier>(
        builder: (context, bookMarkNotifier, child) {
      if (bookMarkNotifier.isUpdated) {
        loadOffCampusData();
        _loadOffCampusRecData();
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
                    OfCaRecommend(
                      thisSelectedText: widget.thisSelectedText,
                      thisCurrentStage: widget.thisCurrentStage,
                      roadmapId: widget.thisSelectedId,
                      thisOffCampusRecData: _offCampusRecData,
                      isRecLoading: _isRecLoading,
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
                : offCampusData.isNotEmpty
                    ? SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final item = offCampusData[index];
                            return Container(
                              decoration: BoxDecoration(
                                color: AppColors.white,
                                borderRadius: index == 0
                                    ? const BorderRadius.only(
                                        topLeft: Radius.circular(2),
                                        topRight: Radius.circular(2),
                                      )
                                    : index == offCampusData.length - 1
                                        ? const BorderRadius.only(
                                            bottomLeft: Radius.circular(2),
                                            bottomRight: Radius.circular(2),
                                          )
                                        : null,
                              ),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Column(
                                children: [
                                  OfCaList(
                                    thisOrganize: item.department,
                                    thisID: item.announcementId.toString(),
                                    thisClassification: '',
                                    thisTitle: item.title,
                                    thisDDay: item.dday.toString(),
                                    isSaved: item.isBookMarked,
                                  ),
                                  if (index < offCampusData.length - 1)
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                      child: CustomDivider(),
                                    ),
                                ],
                              ),
                            );
                          },
                          childCount: offCampusData.length,
                        ),
                      )
                    : SliverFillRemaining(
                        fillOverscroll: true,
                        hasScrollBody: false,
                        child: GotoSaveItem(
                          tapAction: () {
                            IntergrateScreen.setSelectedIndexToZero(context);
                          },
                        ),
                      ),
          ],
        ),
      );
    });
  }
}
