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

  const TabScreenOfCaBiz({
    super.key,
    required this.thisSelectedText,
  });

  @override
  State<TabScreenOfCaBiz> createState() => _TabScreenOfCaBizState();
}

class _TabScreenOfCaBizState extends State<TabScreenOfCaBiz> {
  List<OffCampusModel> filteredItems = [];
  List<dynamic> jsonData = [];

  @override
  void initState() {
    super.initState();
    _loadJsonData().then((_) {
      _loadAndMatchItems(); // JSON 데이터 로딩 후 _loadAndMatchItems 호출
    });
  }

  Future<void> _loadJsonData() async {
    var jsonString =
        await rootBundle.loadString('lib/data_manage/outschool_gara.json');
    var jsonRawData = json.decode(jsonString) as List;
    jsonData =
        jsonRawData.map((item) => OffCampusModel.fromJson(item)).toList();
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
          var matchingItem = jsonData.firstWhere((offCampusItem) =>
              offCampusItem.id ==
              itemId.toString()); // 명시적으로 OffCampusModel? 타입으로 반환

          if (matchingItem != null) {
            matchingData.add(matchingItem);
          }
        }
      }
      if (mounted) {
        // mounted 상태 확인
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  style: AppTextStyles.caption.copyWith(color: AppColors.g5),
                ),
              ],
            ),
          ),
          Gaps.v20,
          Expanded(
            child: Consumer<RoadMapModel>(
              // RoadMapModel의 상태 변화를 감지
              builder: (context, roadmapModel, child) {
                if (roadmapModel.hasUpdated) {
                  _loadAndMatchItems(); // 업데이트가 필요할 때만 아이템 로딩
                  roadmapModel.resetUpdateFlag(); // 플래그 리셋
                }

                if (filteredItems.isNotEmpty) {
                  // 리스트에 아이템이 있는 경우
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      OffCampusModel item = filteredItems[index];
                      return OfCaCard(
                        thisOrganize: item.organize,
                        thisID: item.id,
                        thisClassification: item.classification,
                        thisTitle: item.title,
                        thisStartdate: item.startDate,
                        thisEnddate: item.endDate,
                      );
                    },
                  );
                } else {
                  // 리스트가 비어 있는 경우
                  return GotoSaveItem(
                    tapAction: () {
                      IntergrateScreen.setSelectedIndexToZero(context);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
