import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';
import 'package:starting_block/screen/manage/models/offcampus_detail_model.dart';
import 'package:starting_block/screen/manage/models/offcampus_recommend_model.dart';

class OffCampusDetail extends StatefulWidget {
  final String thisID;

  const OffCampusDetail({
    super.key,
    required this.thisID,
  });

  @override
  State<OffCampusDetail> createState() => _OffCampusDetailState();
}

class _OffCampusDetailState extends State<OffCampusDetail> {
  String thisOrganize = 'N/A';
  String thisTitle = 'N/A';
  String thisStartDate = 'N/A';
  String thisEndDate = 'N/A';
  String thisAge = 'N/A';
  String thisType = 'N/A';
  String thisLink = 'N/A';
  String thisID = 'N/A';
  String thisClassification = 'N/A'; //<- 여기까지가 데이터 모델에서 받아오는 데이터
  late Future<List<OffCampusRecommendModel>> futureRecommendations;

  @override
  void initState() {
    super.initState();
    loadoffCampusDetailData();

    // loadJsonData 함수를 사용하여 futureRecommendations 초기화
    futureRecommendations = loadJsonData();
  }

  Future<void> loadoffCampusDetailData() async {
    String jsonString =
        await rootBundle.loadString('lib/data_manage/outschool_gara.json');
    List<dynamic> jsonData = json.decode(jsonString);
    setState(() {
      var detailJson = jsonData.firstWhere(
        (element) => element['id'].toString() == widget.thisID,
        orElse: () => null,
      );
      if (detailJson != null) {
        var detailData = OffCampusDetailModel.fromJson(detailJson);
        thisOrganize = detailData.organize;
        thisTitle = detailData.title;
        thisStartDate = detailData.startDate;
        thisEndDate = detailData.endDate;
        thisAge = detailData.age;
        thisType = detailData.type;
        thisLink = detailData.link;
        thisID = detailData.id;
        thisClassification = detailData.classification;
      }
    });
  }

  Future<List<OffCampusRecommendModel>> loadJsonData() async {
    String jsonString =
        await rootBundle.loadString('lib/data_manage/outschool_gara.json');
    List<dynamic> jsonData = json.decode(jsonString);
    List<OffCampusRecommendModel> recommendations = jsonData
        .where((item) => item['id'].toString() != widget.thisID)
        .map((item) => OffCampusRecommendModel.fromJson(item))
        .toList();
    recommendations.shuffle();
    return recommendations.take(3).toList(); // 여기서 3개 아이템만 선택
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SaveAppBar(
        thisBookMark: BookMarkButton(
          id: thisID,
          classification: thisClassification,
        ),
      ),
      body: SingleChildScrollView(
        // SingleChildScrollView로 감싸기
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OffCampusDetailBody(
              organize: thisOrganize,
              title: thisTitle,
              startDate: thisStartDate,
              endDate: thisEndDate,
              age: thisAge,
              type: thisType,
              link: thisLink,
              thisID: widget.thisID,
              classification: thisClassification,
            ),
            Container(
              height: 8,
              decoration: const BoxDecoration(color: AppColors.g1),
            ),
            Recommendation(
              futureRecommendations: futureRecommendations,
              thisID: thisID,
            )
          ],
        ),
      ),
    );
  }
}
