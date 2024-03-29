import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/api/offcampus_api_manage.dart';
import 'package:starting_block/screen/manage/api/question_answer_api_manage.dart';
import 'package:starting_block/screen/manage/model_manage.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';

class WebViewScreen extends StatefulWidget {
  final String url, id, classification;

  const WebViewScreen({
    super.key,
    required this.url,
    required this.id,
    required this.classification,
  });

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  int _questionCount = 0;
  final List<OffCampusDetailModel> _offcampusDetail = [];

  @override
  void initState() {
    super.initState();
    loadoffCampusDetailData();
    loadQuestionData();
  }

  Future<void> loadoffCampusDetailData() async {
    int id = int.parse(widget.id);
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
        await QuestionAnswerApi.getQuestionData(widget.id);
    setState(() {
      _questionCount = questionData.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookMarkNotifier>(
      builder: (context, bookMarkNotifier, child) {
        if (bookMarkNotifier.isUpdated) {
          loadoffCampusDetailData();
          loadoffCampusDetailData();
          bookMarkNotifier.resetUpdate();
        }

        return Scaffold(
          appBar: _offcampusDetail.isNotEmpty
              ? SaveAppBar(
                  thisBookMark: BookMarkButton(
                    isSaved: _offcampusDetail[0].isBookmarked,
                    thisID: widget.id,
                  ),
                )
              : null,
          body: Stack(
            children: [
              InAppWebView(
                initialUrlRequest:
                    URLRequest(url: WebUri(widget.url)), // 여기를 수정합니다
                // 필요한 경우 추가 InAppWebView 설정을 여기에 추가할 수 있습니다.
              ),
              const Positioned(
                bottom: 0,
                child: BottomGradient(),
              ),
            ],
          ),
          bottomNavigationBar: BottomAppBar(
            height: 48,
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: AppColors.white,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                ),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuestionHome(
                          thisID: widget.id,
                        ),
                      ),
                    );
                  },
                  child: FractionallySizedBox(
                    widthFactor: 1,
                    heightFactor: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.blue,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '질문하기',
                            style: AppTextStyles.btn1
                                .copyWith(color: AppColors.white),
                          ),
                          Gaps.h12,
                          Text(
                            _questionCount.toString(),
                            style: AppTextStyles.btn1
                                .copyWith(color: AppColors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
