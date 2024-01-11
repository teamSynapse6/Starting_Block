import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/bookmark_manage.dart';
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
  String thisID = 'N/A'; //<- 여기까지가 데이터 모델에서 받아오는 데이터
  bool isSaved = false;
  late BookMarkManager bookMarkManager; //<- 여기까지가 북마크 기능구현
  late Future<List<OffCampusRecommendModel>>
      futureRecommendations; //<-추천 화면 재로딩 금지

  @override
  void initState() {
    super.initState();
    loadoffCampusDetailData();
    initFutureRecommendations();
    bookMarkManager = BookMarkManager();
    bookMarkManager.initPrefs();
    checkBookMarkStatus();
  }

  void initFutureRecommendations() {
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

  void checkBookMarkStatus() async {
    bool saved = await bookMarkManager.isBookMarked(widget.thisID);
    setState(() {
      isSaved = saved;
    });
  }

  onBookMarkTap() async {
    await bookMarkManager.toggleBookMark(widget.thisID);
    checkBookMarkStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SaveAppBar(
        isSaved: isSaved,
        bookMarkTap: onBookMarkTap,
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
            ),
            Container(
              height: 8,
              decoration: const BoxDecoration(color: AppColors.g1),
            ),
            Recommendation(
              futureRecommendations: futureRecommendations,
              thisID: thisID,
            ),
          ],
        ),
      ),
    );
  }
}
