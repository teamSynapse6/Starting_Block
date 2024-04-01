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
    // 현재까지 로드된 데이터의 개수를 기반으로 전체 데이터를 다시 로드합니다.
    var result = await OffCampusApi.getOffCampusHomeList(
      page: 0, // 처음부터 데이터를 다시 로드하기 때문에 페이지는 0으로 설정합니다.
      size: _offcampusList.length, // 현재까지 로드된 데이터의 총 개수를 size로 설정합니다.
      sorting: _sorting,
      postTarget: _postTarget,
      region: _region,
      supportType: _supportType,
      search: _controller.text, // 검색어도 포함하여 요청합니다.
    );

    // API 호출 결과로 받은 데이터로 상태를 업데이트합니다.
    List<OffCampusListModel> reloadedData = result['offCampusList'];
    // bool last = result['last'];

    setState(() {
      _offcampusList = reloadedData; // 새로 로드된 데이터로 리스트를 업데이트합니다.
      // _hasMoreData = !last; // 'last' 값에 따라 더 로드할 데이터가 있는지 업데이트합니다.
      // _pageNumber = (reloadedData.length ~/ 20); // 페이지 번호도 업데이트합니다.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchFiledAppBar(
        hintText: '검색어를 입력해주세요',
        controller: _controller,
        recentSearchManager: recentSearchManager,
        onBackTap: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const OffCampusSearch()),
            (Route<dynamic> route) => false,
          );
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

          return Column(
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
                            style:
                                AppTextStyles.bd6.copyWith(color: AppColors.g4),
                          ),
                          const Spacer(),
                          const OffCampusSortingButton(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Consumer<BookMarkNotifier>(
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
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: _offcampusList.length,
                        itemBuilder: (context, index) {
                          final item = _offcampusList[index];
                          return ItemList(
                            thisID: item.announcementId.toString(),
                            thisOrganize: item.departmentName,
                            thisTitle: item.title,
                            thisStartDate: item.startDate,
                            thisEndDate: item.endDate,
                            thisClassification: '교외사업',
                            isSaved: item.isBookmarked,
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
