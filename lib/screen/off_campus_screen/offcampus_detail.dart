// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/offcampus_api_manage.dart';
import 'package:starting_block/manage/api/question_answer_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';

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
  String _questionCount = '0';
  Future<List<OffCampusListModel>>? futureRecommendations; // 추천 공고 데이터를 저장할 필드
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    print('ID: ${widget.thisID}');
    loadoffCampusDetailData();
    loadRecommendations(); // 추천 공고 데이터를 로드하는 메소드 호출
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
      isLoading = false;
    });
  }

  // 추천 공고 데이터를 로드하는 메소드
  void loadRecommendations() {
    futureRecommendations = OffCampusApi.getOffcampusRecommend();
  }

  void loadQuestionData() async {
    final questions = await QuestionAnswerApi.getQuestionList(
        int.tryParse(widget.thisID) ?? 0);
    setState(() {
      _questionCount = questions.length.toString(); // _questionData 업데이트
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookMarkNotifier>(
      builder: (context, bookMarkNotifier, child) {
        if (bookMarkNotifier.isUpdated) {
          loadoffCampusDetailData();
        }
        return Scaffold(
          appBar: _offcampusDetail.isNotEmpty
              ? SaveAppBar(
                  thisBookMark: BookMarkButton(
                    isSaved: _offcampusDetail[0].isBookmarked,
                    thisID: widget.thisID,
                  ),
                )
              : null,
          body: SingleChildScrollView(
            physics: isLoading
                ? const NeverScrollableScrollPhysics()
                : const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isLoading)
                  const OffCampusDetailSkeleton()
                else if (_offcampusDetail.isNotEmpty && !isLoading)
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
                    questionCount: _questionCount,
                    thisLoadAction: loadQuestionData,
                    isContatcExist: _offcampusDetail[0].isContactExist,
                  ),
                if (_offcampusDetail.isNotEmpty &&
                    _offcampusDetail[0].isFileUploaded &&
                    !isLoading)
                  OffCampusDetailGptCard(
                    thisTitle: _offcampusDetail[0].title,
                    thisID: widget.thisID,
                  ),
                Container(
                  height: 8,
                  decoration: const BoxDecoration(color: AppColors.g1),
                ),
                if (isLoading)
                  const OffCampusDetailRecommendSkeleton()
                else if (futureRecommendations != null && !isLoading)
                  Recommendation(
                    futureRecommendations: futureRecommendations!,
                    thisID: widget.thisID,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
