import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/api/offcampus_api_manage.dart';
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
  String thisClassification = 'N/A';
  late Future<List<OffCampusRecommendModel>> futureRecommendations;

  @override
  void initState() {
    super.initState();
    loadoffCampusDetailData();
    futureRecommendations = OffCampusApiService.getOffCampusRecData(
      widget.thisID,
    ); // Updated to use OffCampusApiService
  }

  Future<void> loadoffCampusDetailData() async {
    List<OffCampusDetailModel> data =
        await OffCampusApiService.getOffCampusDetailData();
    setState(() {
      var detailData = data.firstWhere(
        (element) => element.id == widget.thisID,
      );
      thisOrganize = detailData.organize;
      thisTitle = detailData.title;
      thisStartDate = detailData.startDate;
      thisEndDate = detailData.endDate;
      thisAge = detailData.age;
      thisType = detailData.type;
      thisLink = detailData.link;
      thisID = detailData.id;
      thisClassification = detailData.classification;
    });
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
