import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/roadmap_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';
import 'package:starting_block/screen/roadmap_screen/tabscreen/oncampus_class/onca_class_recommend.dart';

const List<String> validTextsClass = globalDataRoadmapList;

class TabScreenOnCaClass extends StatefulWidget {
  final String thisSelectedText;
  final int thisSelectedId;
  final bool thisCurrentStage;

  const TabScreenOnCaClass({
    super.key,
    required this.thisSelectedText,
    required this.thisCurrentStage,
    required this.thisSelectedId,
  });

  @override
  State<TabScreenOnCaClass> createState() => _TabScreenOnCaClassState();
}

class _TabScreenOnCaClassState extends State<TabScreenOnCaClass> {
  List<int> savedIds = [];
  List<RoadMapSavedClassModel> onCampusClassData = [];
  bool isLoading = true;
  bool bookMarkIsUpdated = false;

  @override
  void initState() {
    super.initState();
    loadOnCampusClassData();
  }

  @override
  void didUpdateWidget(TabScreenOnCaClass oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.thisSelectedText != widget.thisSelectedText) {
      loadOnCampusClassData();
    }
  }

  void loadOnCampusClassData() async {
    List<RoadMapSavedClassModel> loadedData = await RoadMapApi.getSavedLecture(
      roadmapId: widget.thisSelectedId,
    );
    setState(() {
      onCampusClassData = loadedData;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookMarkNotifier>(
        builder: (context, bookMarkNotifier, child) {
      if (bookMarkNotifier.isUpdated) {
        loadOnCampusClassData();
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
                  if (validTextsClass.contains(widget.thisSelectedText))
                    OnCaClassRecommend(
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
                ? const RoadMapClassTabSkeleton()
                : onCampusClassData.isNotEmpty
                    ? SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final item = onCampusClassData[index];
                            return Column(
                              children: [
                                OnCaListClass(
                                  thisTitle: item.title,
                                  thisId: item.lectureId.toString(),
                                  thisLiberal: item.liberal,
                                  thisCredit: item.credit.toString(),
                                  thisContent: item.content,
                                  thisSession: item.session.toString(),
                                  thisInstructor: item.instructor,
                                  thisBookMaekSaved: item.isBookmarked,
                                ),
                                Gaps.v16,
                              ],
                            );
                          },
                          childCount: onCampusClassData.length,
                        ),
                      )
                    : SliverFillRemaining(
                        fillOverscroll: true,
                        hasScrollBody: false,
                        child: GotoSaveItem(
                          tapAction: () {
                            IntergrateScreen.setSelectedIndexToOne(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const OnCampusClass(),
                              ),
                            );
                          },
                        ),
                      ),
          ],
        ),
      );
    });
  }
}
