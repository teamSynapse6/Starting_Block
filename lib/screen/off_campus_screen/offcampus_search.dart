import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/recentsearch_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';

class OffCampusSearch extends StatefulWidget {
  const OffCampusSearch({super.key});

  @override
  State<OffCampusSearch> createState() => _OffCampusSearchState();
}

class _OffCampusSearchState extends State<OffCampusSearch> {
  final TextEditingController _controller = TextEditingController();
  List<String> recentSearches = [];
  final RecentSearchManager recentSearchManager = RecentSearchManager();
  final List<String> _popularKeywords = [
    '서울',
    '창업',
    '청년창업지원'
  ]; // 인기 검색어 목록을 저장할 리스트

  @override
  void initState() {
    super.initState();
    loadRecentSearches();
    loadPopularKeywords(); // 인기 검색어를 로드하는 메소드 호출
    recentSearchManager.onSearchUpdate = loadRecentSearches;
  }

  @override
  void dispose() {
    recentSearchManager.onSearchUpdate = null;
    super.dispose();
  }

  Future<void> loadRecentSearches() async {
    recentSearches = await recentSearchManager.loadRecentSearches();
    setState(() {});
  }

  Future<void> deleteSearch(String search) async {
    await recentSearchManager.deleteSearch(search);
    loadRecentSearches();
  }

  void navigateToSearchResult(String query) async {
    final bool? isUpdated = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OffCampusSearchResult(searchWord: query),
      ),
    );

    // isUpdated가 null이 아니고 true이면 최신 검색 목록을 다시 불러옵니다.
    if (isUpdated != null && isUpdated) {
      loadRecentSearches();
    }
  }

  Future<void> deleteAllSearch() async {
    await recentSearchManager.deleteAllSearches();
    loadRecentSearches();
  }

  Future<void> loadPopularKeywords() async {
    // List<String> popularKeyword =
    //     await OffCampusApi.getOffCampusPopularKeyword(); // 인기 검색어 로드
    // setState(() {
    //   _popularKeywords.clear();
    //   _popularKeywords.addAll(popularKeyword);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: SearchFiledAppBar(
          hintText: '검색어를 입력하세요',
          controller: _controller,
          recentSearchManager: recentSearchManager,
          onBackTap: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => const IntergrateScreen(
                        switchIndex: SwitchIndex.toZero,
                      )),
              (Route<dynamic> route) => false,
            );
          },
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gaps.v24,
              recentSearches.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              '최근 검색어',
                              style: AppTextStyles.st2
                                  .copyWith(color: AppColors.g6),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: deleteAllSearch,
                              child: Text(
                                '전체 삭제',
                                style: AppTextStyles.btn1
                                    .copyWith(color: AppColors.g5),
                              ),
                            ),
                          ],
                        ),
                        Gaps.v16,
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: recentSearches.map((search) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: InputChipsDelete(
                                  thisIcon: AppIcon.close,
                                  text: search,
                                  deleteTap: () => deleteSearch(search),
                                  chipTap: () =>
                                      navigateToSearchResult(search), // 여기에 추가
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Gaps.v64,
                      ],
                    )
                  : Container(),
              Text(
                '인기 검색어',
                style: AppTextStyles.st2.copyWith(color: AppColors.g6),
              ),
              Gaps.v16,
              Wrap(
                runSpacing: 12,
                spacing: 12,
                children: _popularKeywords.map((keyword) {
                  // 인기 검색어 목록을 바탕으로 동적으로 위젯 생성
                  return InputChupsSharp(
                    text: keyword,
                    chipTap: () => navigateToSearchResult(keyword),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
