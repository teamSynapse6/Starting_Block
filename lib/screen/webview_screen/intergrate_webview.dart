import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/offcampus_api_manage.dart';
import 'package:starting_block/manage/api/qestion_answer_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';

class WebViewScreen extends StatefulWidget {
  final String url, id;

  const WebViewScreen({
    super.key,
    required this.url,
    required this.id,
  });

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  String _questionCount = '0';
  final List<OffCampusDetailModel> _offcampusDetail = [];
  bool _isBottomAppBarVisible = true;
  int _lastScrollY = 0;
  bool _isScrollingDown = false;

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

  void loadQuestionData() async {
    final questions =
        await QuestionAnswerApi.getQuestionList(int.tryParse(widget.id) ?? 0);
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
                onScrollChanged: (controller, x, y) {
                  bool isScrollingDown = y > _lastScrollY;

                  if (isScrollingDown != _isScrollingDown) {
                    // 스크롤 방향이 바뀌면 상태 업데이트
                    setState(() {
                      _isBottomAppBarVisible = !isScrollingDown;
                    });
                    _isScrollingDown = isScrollingDown;
                  }

                  _lastScrollY = y; // 마지막 스크롤 위치 업데이트
                },
              ),
              Positioned(
                bottom: 0,
                child: AnimatedOpacity(
                  opacity: _isBottomAppBarVisible ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 100),
                  child: const BottomGradient(),
                ),
              ),
            ],
          ),
          bottomNavigationBar: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            height: _isBottomAppBarVisible ? 48 : 0,
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
                            _questionCount,
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
