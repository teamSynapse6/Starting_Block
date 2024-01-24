// ignore_for_file: avoid_print
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:starting_block/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starting_block/screen/manage/models/offcampus_model.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';

class TabScreenOfCaBiz extends StatefulWidget {
  final String thisSelectedText;
  final bool thisCurrentStage;

  const TabScreenOfCaBiz({
    super.key,
    required this.thisSelectedText,
    required this.thisCurrentStage,
  });

  @override
  State<TabScreenOfCaBiz> createState() => _TabScreenOfCaBizState();
}

class _TabScreenOfCaBizState extends State<TabScreenOfCaBiz> {
  List<OffCampusModel> filteredItems = [];
  List<OffCampusModel> randomItems = [];
  List<OffCampusModel> jsonData = [];

  @override
  void initState() {
    super.initState();
    _loadJsonData().then((_) {
      _loadAndMatchItems();
      _selectRandomItems();
    });
  }

  Future<void> _loadJsonData() async {
    var jsonString =
        await rootBundle.loadString('lib/data_manage/outschool_gara.json');
    var jsonRawData = json.decode(jsonString) as List;
    setState(() {
      jsonData = jsonRawData
          .map((item) => OffCampusModel.fromJson(item as Map<String, dynamic>))
          .toList();
    });
  }

  void _selectRandomItems() {
    final random = Random();
    List<OffCampusModel> itemsToConsider =
        jsonData.where((item) => !filteredItems.contains(item)).toList();

    Set<int> indexes = {};

    while (indexes.length < 5 && indexes.length < itemsToConsider.length) {
      indexes.add(random.nextInt(itemsToConsider.length));
    }
    if (mounted) {
      setState(() {
        randomItems = indexes.map((index) => itemsToConsider[index]).toList();
      });
    }
  }

  void _loadAndMatchItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedItemsString = prefs.getString(widget.thisSelectedText);

    if (savedItemsString != null) {
      List<dynamic> allItemsDynamic = json.decode(savedItemsString);
      List<Map<String, dynamic>> allItems =
          allItemsDynamic.map((item) => item as Map<String, dynamic>).toList();

      List<OffCampusModel> matchingData = [];

      for (var item in allItems) {
        int? itemId = int.tryParse(item['id']);
        if (itemId != null) {
          var matchingItem = jsonData.firstWhere(
              (offCampusItem) => offCampusItem.id == itemId.toString());

          matchingData.add(matchingItem);
        }
      }
      if (mounted) {
        setState(() {
          filteredItems = matchingData;
        });
      }
    }
    print('이건 필터링: $filteredItems');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryBG,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gaps.v24,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Text("추천 사업",
                          style: AppTextStyles.st2
                              .copyWith(color: AppColors.blue)),
                      Text("이 도착했습니다",
                          style:
                              AppTextStyles.st2.copyWith(color: AppColors.g6)),
                    ],
                  ),
                ),
                Gaps.v16,
                Stack(
                  children: [
                    SizedBox(
                      height: 148,
                      child: PageView.builder(
                        controller: PageController(
                            viewportFraction:
                                312 / MediaQuery.of(context).size.width),
                        itemCount: randomItems.length,
                        itemBuilder: (context, index) {
                          OffCampusModel item = randomItems[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: OfCaCard(
                              thisOrganize: item.organize,
                              thisID: item.id,
                              thisClassification: item.classification,
                              thisTitle: item.title,
                              thisEnddate: item.endDate,
                            ),
                          );
                        },
                      ),
                    ),
                    !widget.thisCurrentStage
                        ? Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            height: 150,
                            child: ClipRect(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                child: Container(
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    !widget.thisCurrentStage
                        ? SizedBox(
                            height: 148,
                            child: Center(
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: AppColors.g4,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 12,
                                  ),
                                  child: Text(
                                    '도약하고 추천사업 받아보기',
                                    style: AppTextStyles.btn2
                                        .copyWith(color: AppColors.white),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
                Gaps.v24,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '저장한 사업으로 도약하기',
                        style: AppTextStyles.st2.copyWith(color: AppColors.g6),
                      ),
                      Gaps.v4,
                      Text(
                        '신청 완료한 사업은 도약 완료 버튼으로 진행도 확인하기',
                        style:
                            AppTextStyles.caption.copyWith(color: AppColors.g5),
                      ),
                    ],
                  ),
                ),
                Gaps.v20,
              ],
            ),
          ),
          Consumer<RoadMapModel>(
            builder: (context, roadmapModel, child) {
              if (roadmapModel.hasUpdated) {
                _loadAndMatchItems(); // 업데이트가 필요할 때만 아이템 로딩
                roadmapModel.resetUpdateFlag(); // 플래그 리셋
              }
              if (filteredItems.isNotEmpty) {
                // filteredItems에 아이템이 있는 경우 SliverList를 반환합니다.
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Container(
                        color: AppColors.white,
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            OfCaList(
                              thisOrganize: filteredItems[index].organize,
                              thisID: filteredItems[index].id,
                              thisClassification:
                                  filteredItems[index].classification,
                              thisTitle: filteredItems[index].title,
                              thisEnddate: filteredItems[index].endDate,
                            ),
                            if (index < filteredItems.length - 1)
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 16),
                                child: CustomDivider(),
                              ),
                          ],
                        ),
                      );
                    },
                    childCount: filteredItems.length,
                  ),
                );
              } else {
                // filteredItems가 비어 있는 경우 다른 위젯을 반환합니다.
                return SliverToBoxAdapter(
                  child: GotoSaveItem(
                    tapAction: () {
                      IntergrateScreen.setSelectedIndexToZero(context);
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
