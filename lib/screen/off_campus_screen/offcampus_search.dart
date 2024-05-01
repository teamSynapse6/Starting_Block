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
    '청년창업지원',
    '서울',
    '창업',
    '청년창업지원'
  ];

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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gaps.v24,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                '인기 검색어',
                style: AppTextStyles.st2.copyWith(color: AppColors.g6),
              ),
            ),
            Gaps.v16,
            SizedBox(
              height: 32, // 충분한 높이 설정
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _popularKeywords.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      left: index == 0 ? 24 : 0,
                      right: 12,
                    ),
                    child: InputChips(
                      text: _popularKeywords[index],
                      chipTap: () =>
                          navigateToSearchResult(_popularKeywords[index]),
                    ),
                  );
                },
              ),
            ),
            Gaps.v48,
            recentSearches.isNotEmpty
                ? Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Row(
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
                        ),
                        Gaps.v8,
                        Expanded(
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: recentSearches.length,
                            itemBuilder: (context, index) {
                              final search = recentSearches[index];
                              return SearchHistoryList(
                                thisText: search,
                                thisTap: () => navigateToSearchResult(search),
                                thisDeleteTap: () => deleteSearch(search),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
