import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/offcampus_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/recentsearch_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';

class OffCampusSearchResult extends StatefulWidget {
  final String searchWord; // 검색어를 저장할 변수

  const OffCampusSearchResult({
    super.key,
    required this.searchWord,
  });

  @override
  State<OffCampusSearchResult> createState() => _OffCampusSearchResultState();
}

class _OffCampusSearchResultState extends State<OffCampusSearchResult> {
  final TextEditingController _controller = TextEditingController();
  final RecentSearchManager recentSearchManager = RecentSearchManager();
  List<OffCampusListModel> _offcampusList = [];
  final ScrollController _scrollController = ScrollController();
  int _pageNumber = 0; // 현재 페이지 번호
  bool _hasMoreData = true; // 더 불러올 데이터가 있는지 여부
  String _postTarget = '';
  String _region = '';
  String _supportType = '';
  String _sorting = '';
  bool _isScrolled = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.searchWord;
    recentSearchManager.addSearch(widget.searchWord);
    _scrollController.addListener(_onScroll);
    loadFilterValue();
  }

  void loadFilterValue() {
    var filterModel = Provider.of<FilterModel>(context, listen: false);
    String postTarget = filterModel.selectedEntrepreneur == "전체"
        ? ''
        : filterModel.selectedEntrepreneur;
    String region = filterModel.selectedResidence == "전체"
        ? ''
        : filterModel.selectedResidence;
    String supportType = filterModel.selectedSupportType == "전체"
        ? ''
        : filterModel.selectedSupportType;
    String sorting =
        filterModel.selectedSorting; // 정렬 상태는 "전체"와 같은 선택이 없으므로 그대로 사용

    setState(() {
      _postTarget = postTarget;
      _region = region;
      _supportType = supportType;
      _sorting = sorting;
    });

    _loadOffCampusList();
  }

  Future<void> _loadOffCampusList() async {
    setState(() {
      _isLoading = true;
    });
    var result = await OffCampusApi.getOffCampusHomeList(
      page: _pageNumber,
      sorting: _sorting,
      postTarget: _postTarget,
      region: _region,
      supportType: _supportType,
      search: _controller.text,
    );

    // 결과에서 공고 리스트와 'last' 값을 추출합니다.
    List<OffCampusListModel> offCampusList = result['offCampusList'];
    bool last = result['last'];

    setState(() {
      _offcampusList.clear(); // 기존 목록을 지우고 새 데이터로 채웁니다.
      _offcampusList.addAll(offCampusList);
      _hasMoreData = !last; // 'last' 값에 따라 _hasMoreData를 업데이트합니다.
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (_hasMoreData) {
        _loadMoreData();
      }
    }
    if (_scrollController.offset == 0) {
      setState(() {
        _isScrolled = false;
      });
    }
    if (_scrollController.offset != 0) {
      setState(() {
        _isScrolled = true;
      });
    }
  }

  Future<void> _loadMoreData() async {
    // 페이지 번호를 증가시킵니다.
    _pageNumber++;
    var result = await OffCampusApi.getOffCampusHomeList(
      page: _pageNumber,
      sorting: _sorting,
      postTarget: _postTarget,
      region: _region,
      supportType: _supportType,
    );

    // 결과에서 공고 리스트와 'last' 값을 추출합니다.
    List<OffCampusListModel> moreOffcampusList = result['offCampusList'];
    bool last = result['last'];
    setState(() {
      _offcampusList.addAll(moreOffcampusList);
      if (last) {
        _hasMoreData = false;
      } else {
        _hasMoreData = true;
      }
    });
  }

  Future<void> _reloadAllData() async {
    int totalLoadedDataCount = _offcampusList.length;

    var result = await OffCampusApi.getOffCampusHomeList(
      page: 0,
      size: totalLoadedDataCount,
      sorting: _sorting,
      postTarget: _postTarget,
      region: _region,
      supportType: _supportType,
    );

    List<OffCampusListModel> reloadedData = result['offCampusList'];

    setState(() {
      _offcampusList = reloadedData;
    });
  }

  void backToTopTap() {
    _scrollController.animateTo(
      0.0, // 최상단 위치
      duration: const Duration(milliseconds: 300), // 애니메이션 지속 시간
      curve: Curves.easeOut, // 애니메이션 곡선 설정
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchResultAppBar(
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
      body: Consumer<FilterModel>(
        builder: (context, filterModel, child) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (filterModel.hasChanged) {
              _pageNumber = 0;
              loadFilterValue();
              filterModel.resetChangeFlag();
            }
          });

          return Stack(
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Gaps.v12,
                        const IntergrateFilter(),
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
                                '${_offcampusList.length}개의 공고',
                                style: AppTextStyles.bd6
                                    .copyWith(color: AppColors.g4),
                              ),
                              const Spacer(),
                              const OffCampusSortingButton(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _isLoading
                      ? const Expanded(
                          child: OffCampusHomeSkeleton(),
                        )
                      : Consumer<BookMarkNotifier>(
                          builder: (context, bookMarkNotifier, child) {
                            if (bookMarkNotifier.isUpdated) {
                              _reloadAllData();
                              bookMarkNotifier.resetUpdate();
                            }
                            return Expanded(
                              child: RefreshIndicator(
                                color: AppColors.blue,
                                onRefresh: () async {
                                  // 새로고침 로직을 실행합니다.
                                  _pageNumber = 0; // 페이지 번호를 초기화합니다.
                                  loadFilterValue(); // 데이터를 다시 로드합니다.
                                },
                                child: ListView.builder(
                                  controller: _scrollController,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24),
                                  itemCount: _offcampusList.length,
                                  itemBuilder: (context, index) {
                                    final item = _offcampusList[index];
                                    return Column(
                                      children: [
                                        ItemList(
                                          thisID:
                                              item.announcementId.toString(),
                                          thisOrganize: item.departmentName,
                                          thisTitle: item.title,
                                          thisStartDate: item.startDate,
                                          thisEndDate: item.endDate,
                                          thisClassification: '교외사업',
                                          isSaved: item.isBookmarked,
                                          isContactExist: item.isContactExist,
                                          isFileUploaded: item.isFileUploaded,
                                        ),
                                        Gaps.v16,
                                        if (index != _offcampusList.length - 1)
                                          const CustomDividerH2G1()
                                      ],
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                ],
              ),
              _isScrolled
                  ? Positioned(
                      right: 24,
                      bottom: 15 + 9,
                      child: ScrollToTopButton(
                        thisBackToTopTap: backToTopTap,
                      ))
                  : Container()
            ],
          );
        },
      ),
    );
  }
}
