import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/recentsearch_manage.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';

const interests = [
  "Daily Life",
  "Comedy",
  "Entertainment",
  "Animals",
  "Food",
  "Beauty & Style",
  "Drama",
  "Learning",
  "Talent",
  "Sports",
  "Auto",
  "Family",
  "Fitness & Health",
  "DIY & Life Hacks",
];

class OffCampusSearch extends StatefulWidget {
  const OffCampusSearch({super.key});

  @override
  State<OffCampusSearch> createState() => _OffCampusSearchState();
}

class _OffCampusSearchState extends State<OffCampusSearch> {
  final TextEditingController _controller = TextEditingController();
  List<String> recentSearches = [];
  final RecentSearchManager recentSearchManager = RecentSearchManager();

  @override
  void initState() {
    super.initState();
    loadRecentSearches();
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
              MaterialPageRoute(builder: (context) => const IntergrateScreen()),
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
                                  thisIcon: AppImages.close,
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
                children: [
                  for (var interest in interests)
                    InputChupsSharp(
                      text: interest,
                      chipTap: () => navigateToSearchResult(interest),
                    )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
