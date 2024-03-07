import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  Map<String, String> filterValues = {}; // 필터 값 상태를 저장할 변수
  final ScrollController _scrollController = ScrollController();
  int _pageNumber = 0; // 현재 페이지 번호
  bool _hasMoreData = true; // 더 불러올 데이터가 있는지 여부

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _fetchFilterValues();
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
    List<OffCampusListModel> moreOffcampusList =
        await OffCampusApi.getOffCampusHomeList(
      page: _pageNumber,
    );
    if (moreOffcampusList.isEmpty) {
      setState(() {
        _hasMoreData = false;
      });
    } else {
      setState(() {
        _offcampusList.addAll(moreOffcampusList);
      });
    }
  }

  Future<void> _fetchFilterValues() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, String> fetchedFilterValues = {
      'selectedSupportType': prefs.getString('selectedSupportType') ?? "전체",
      'selectedResidence': prefs.getString('selectedResidence') ?? "전체",
      'selectedEntrepreneur': prefs.getString('selectedEntrepreneur') ?? "전체",
      'selectedSorting': prefs.getString('selectedSorting') ?? "latest",
    };

    setState(() {
      filterValues = fetchedFilterValues; // 상태 업데이트
    });
    _loadOffCampusList();
  }

  Future<void> _loadOffCampusList() async {
    List<OffCampusListModel> offcampusList =
        await OffCampusApi.getOffCampusHomeList();
    setState(() {
      _offcampusList.clear(); // 기존 목록을 지우고 새 데이터로 채웁니다.
      _offcampusList.addAll(offcampusList);
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
          // FilterModel의 변화를 감지하여 필요한 경우 데이터를 다시 로드
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
                        style: AppTextStyles.st1.copyWith(color: AppColors.g6)),
                    Gaps.v24,
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
                            '${_offcampusList.length.toString()}개의 공고',
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
              Expanded(
                child: Consumer<FilterModel>(
                  builder: (context, filterModel, child) {
                    if (filterModel.hasChanged) {
                      _loadOffCampusList()
                          .then((_) => filterModel.resetChangeFlag());
                    }
                    return ListView.builder(
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
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
