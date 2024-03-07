import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/api/offcampus_api_manage.dart';
import 'package:starting_block/screen/manage/api/question_answer_api_manage.dart';
import 'package:starting_block/screen/manage/model_manage.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';

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
  final List<OffCampusDetailModel> _offcampusDetail = [];
  int _questionCount = 0;

  @override
  void initState() {
    super.initState();
    loadoffCampusDetailData();
    loadQuestionData();
  }

  Future<void> loadoffCampusDetailData() async {
    int id = int.parse(widget.thisID);
    // API 호출을 통해 상세 데이터를 가져옵니다.
    OffCampusDetailModel detailData =
        await OffCampusApi.getOffcampusDetailInfo(id);
    setState(() {
      _offcampusDetail.clear();
      _offcampusDetail.add(detailData);
    });
  }

  Future<void> loadQuestionData() async {
    List<QuestionModel> questionData =
        await QuestionAnswerApi.getQuestionData(widget.thisID);
    setState(() {
      _questionCount = questionData.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SaveAppBar(
        thisBookMark: BookMarkButton(
          id: widget.thisID,
          classification: '교외사업',
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_offcampusDetail.isNotEmpty)
              OffCampusDetailInfo(
                organize: _offcampusDetail[0].organization,
                title: _offcampusDetail[0].title,
                startDate: _offcampusDetail[0].startDate,
                endDate: _offcampusDetail[0].endDate,
                target: _offcampusDetail[0].target,
                type: _offcampusDetail[0].supportType,
                link: _offcampusDetail[0].link,
                thisID: _offcampusDetail[0].id.toString(),
                classification: "교외사업",
                content: _offcampusDetail[0].content,
                questionCount: _questionCount.toString(),
              ),
            Container(
              height: 8,
              decoration: const BoxDecoration(color: AppColors.g1),
            ),
            // Recommendation(
            //   futureRecommendations: futureRecommendations,
            //   thisID: thisID,
            // )
          ],
        ),
      ),
    );
  }
}
