// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/constants/widgets/oncampus_filter/model/onca_filter_model.dart';
import 'package:starting_block/constants/widgets/oncampus_filter/model/onca_sorting_textbuttonsheet.dart';
import 'package:starting_block/manage/api/oncampus_api_manage.dart';
import 'package:starting_block/manage/models/oncampus_model/onca_announcement_model.dart';
import 'package:starting_block/manage/recentsearch_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';

class OnCampusSearchResult extends StatefulWidget {
  final String searchWord; // 검색어를 저장할 변수

  const OnCampusSearchResult({
    super.key,
    required this.searchWord,
  });

  @override
  State<OnCampusSearchResult> createState() => _OnCampusSearchResultState();
}

class _OnCampusSearchResultState extends State<OnCampusSearchResult> {
  final TextEditingController _controller = TextEditingController();
  final RecentSearchManager recentSearchManager = RecentSearchManager();
  bool isLoading = true;
  String _selectedProgram = '';
  List<OncaAnnouncementModel> _searchResult = [];

  @override
  void initState() {
    super.initState();
    _controller.text = widget.searchWord;
    recentSearchManager.addSearch(widget.searchWord);
    loadFilterValue();
  }

  void loadFilterValue() async {
    // selectedProgram 값에 따른 키워드 매핑
    Map<String, String?> programKeywords = {
      '전체': 'null',
      '창업 멘토링': 'MENTORING',
      '창업 동아리': 'CLUB',
      '창업 특강': 'LECTURE',
      '창업 경진대회': 'CONTEST',
      '창업 캠프': 'CAMP',
      '기타': 'ETC'
    };

    var oncaFilterValue = Provider.of<OnCaFilterModel>(context, listen: false);
    String selectedProgram = oncaFilterValue.selectedProgram;
    // String selectedSorting = oncaFilterValue.selectedSorting;

    String? keyword = programKeywords[selectedProgram];
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _selectedProgram = keyword!;
        // _selectedSorting = selectedSorting;
      });
      _loadFilteredOnCampusSearch();
    });
  }

  Future<void> _loadFilteredOnCampusSearch() async {
    try {
      // API 호출
      List<OncaAnnouncementModel> notifyList =
          await OnCampusApi.getOncaAnnouncement(
        keyword: _selectedProgram,
        search: widget.searchWord,
      );

      setState(() {
        _searchResult = notifyList;
        isLoading = false;
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchResultAppBarForOnca(
        hintText: '검색어를 입력해주세요',
        controller: _controller,
        recentSearchManager: recentSearchManager,
        onBackTap: () {
          Navigator.pop(context);
          Navigator.pop(context);
        },
        onCloseTap: () {
          Navigator.pop(context);
        },
      ),
      body: Consumer<OnCaFilterModel>(builder: (context, filterModel, child) {
        if (filterModel.hasChanged) {
          loadFilterValue();
          filterModel.resetChangeFlag();
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gaps.v12,
                  const ProgramChipsSheet(),
                  Gaps.v12,
                  Container(
                    height: 32,
                    decoration: const BoxDecoration(
                      border: BorderDirectional(
                        top: BorderSide(width: 2, color: AppColors.g1),
                        bottom: BorderSide(width: 2, color: AppColors.g1),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_searchResult.length}개의 공고',
                          style:
                              AppTextStyles.bd6.copyWith(color: AppColors.g4),
                        ),
                        const Spacer(),
                        const OnCampusSortingButton(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            isLoading
                ? const Expanded(
                    child: OncaSkeletonSearch(),
                  )
                : Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: _searchResult.length,
                      itemBuilder: (context, index) {
                        final item = _searchResult[index];
                        return Column(
                          children: [
                            OnCampusNotifyListCard(
                              thisProgramText: item.keyword,
                              thisId: item.announcementId.toString(),
                              thisTitle: item.title,
                              thisStartDate: item.insertDate,
                              thisUrl: item.detailUrl,
                              isSaved: item.isBookmarked,
                            ),
                            if (index != _searchResult.length - 1)
                              const CustomDividerH2G1(),
                          ],
                        );
                      },
                    ),
                  ),
          ],
        );
      }),
    );
  }
}
