import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/api/offcampus_api_manage.dart';
import 'package:starting_block/screen/manage/model_manage.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';

class OffCampusHome extends StatefulWidget {
  const OffCampusHome({super.key});

  @override
  State<OffCampusHome> createState() => _OffCampusHomeState();
}

class _OffCampusHomeState extends State<OffCampusHome> {
  final List<OffCampusListModel> _offcampusList = [];
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
    _scrollController.addListener(_onScroll);
    loadFilterValue();
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
    print('마지막?: $last');

    setState(() {
      _offcampusList.addAll(moreOffcampusList);
      if (last) {
        _hasMoreData = false;
      } else {
        _hasMoreData = true;
      }
    });
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
    );

    // Map에서 offCampusList와 last 값을 추출합니다.
    List<OffCampusListModel> offCampusList = result['offCampusList'];
    bool last = result['last'];

    setState(() {
      if (_pageNumber == 0) {
        // 첫 페이지 로드 시 기존 리스트를 클리어합니다.
        _offcampusList.clear();
      }
      _offcampusList.addAll(offCampusList); // 새로운 리스트 항목을 추가합니다.
      _hasMoreData = !last; // 더 로드할 데이터가 있는지 여부를 업데이트합니다.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SearchAppBar(
        searchTapScreen: OffCampusSearch(),
      ),
      body: Consumer<FilterModel>(
        builder: (context, filterModel, child) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (filterModel.hasChanged) {
              _pageNumber = 0; // 필터가 변경되었을 때 페이지 번호를 초기화합니다.
              loadFilterValue();
              filterModel.resetChangeFlag(); // 필터 모델의 변경 플래그를 리셋합니다.
            }
          });
          return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gaps.v12,
                      Text('교외 지원 사업',
                          style:
                              AppTextStyles.st1.copyWith(color: AppColors.g6)),
                      Gaps.v24,
                      const SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: IntergrateFilter(),
                      ),
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
                              '${_offcampusList.length.toString()}개의 공고',
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
                Expanded(
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
                ))
              ]);
        },
      ),
    );
  }
}
