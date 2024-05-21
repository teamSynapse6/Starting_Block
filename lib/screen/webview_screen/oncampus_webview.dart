// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/question_answer_api_manage.dart';
import 'package:starting_block/manage/api/roadmap_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';

class OncampusWebViewScreen extends StatefulWidget {
  final String url, id;

  const OncampusWebViewScreen({
    super.key,
    required this.url,
    required this.id,
  });

  @override
  State<OncampusWebViewScreen> createState() => _OncampusWebViewScreenState();
}

class _OncampusWebViewScreenState extends State<OncampusWebViewScreen> {
  String _questionCount = '0';
  bool _isBottomAppBarVisible = true;
  int _lastScrollY = 0;
  bool _isScrollingDown = false;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();
    loadIsSavedData();
    loadQuestionData();
  }

  void loadIsSavedData() async {
    try {
      // API를 호출하여 저장된 공고 목록을 가져옵니다.
      List<RoadMapAnnounceModel> savedAnnouncements =
          await RoadMapApi.getRoadMapAnnounceList(widget.id);

      // `isAnnouncementSaved`가 true인 항목이 있는지 확인합니다.
      bool isSaved = savedAnnouncements.any((item) => item.isAnnouncementSaved);

      // 상태 업데이트
      setState(() {
        _isSaved = isSaved; // _isSaved 상태를 업데이트합니다.
      });
    } catch (e) {
      return;
    }
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
          loadIsSavedData();
          bookMarkNotifier.resetUpdate();
        }

        return Scaffold(
          appBar: SaveAppBar(
            thisBookMark: BookMarkButton(
              isSaved: _isSaved,
              thisID: widget.id,
            ),
          ),
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
                          isContactExist: false,
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
