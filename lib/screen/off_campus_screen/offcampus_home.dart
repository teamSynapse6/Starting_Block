import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/constants/widgets/offcampus_filter/model/filter_model.dart';
import 'package:starting_block/screen/manage/api/offcampus_api_manage.dart';
import 'package:starting_block/screen/manage/models/offcampus_model.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';

class OffCampusHome extends StatefulWidget {
  const OffCampusHome({super.key});

  @override
  State<OffCampusHome> createState() => _OffCampusHomeState();
}

class _OffCampusHomeState extends State<OffCampusHome> {
  List<OffCampusModel> _offcampusList = [];
  Map<String, String> filterValues = {}; // 필터 값 상태를 저장할 변수
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    _fetchFilterValues();
  }

  Future<void> _fetchFilterValues() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, String> fetchedFilterValues = {
      'selectedSupportType': prefs.getString('selectedSupportType') ?? "전체",
      'selectedResidence': prefs.getString('selectedResidence') ?? "전체",
      'selectedEntrepreneur': prefs.getString('selectedEntrepreneur') ?? "전체",
      // selectedSorting 값을 불러와서 저장합니다.
      'selectedSorting':
          prefs.getString('selectedSorting') ?? "latest", // 기본값을 "latest"로 설정
    };

    setState(() {
      filterValues = fetchedFilterValues; // 상태 업데이트
    });

    // 필터 값이 설정된 후 필터링된 데이터를 불러옵니다.
    _fetchOffCampusDataWithFilters();
  }

  Future<void> _fetchOffCampusDataWithFilters() async {
    if (filterValues.isNotEmpty) {
      try {
        List<OffCampusModel> offcampusList =
            await OffCampusApi.getOffCampusDataFiltered(
          supporttype: filterValues['selectedSupportType']!,
          region: filterValues['selectedResidence']!,
          posttarget: filterValues['selectedEntrepreneur']!,
          sorting: filterValues['selectedSorting']!, // 정렬 조건을 API 호출에 포함
        );
        setState(() {
          _offcampusList = offcampusList;
          isLoaded = true; // 데이터가 로드된 후 상태를 업데이트
        });
      } catch (e) {
        // 에러 처리 로직
        setState(() {
          isLoaded = false; // 데이터 로딩 실패 상태 업데이트
        });
      }
    }
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
                            '24개의 공고',
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
                      _fetchFilterValues()
                          .then((_) => filterModel.resetChangeFlag());
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: _offcampusList.length,
                      itemBuilder: (context, index) {
                        final item = _offcampusList[index];
                        return ItemList(
                          thisID: item.id,
                          thisOrganize: item.organize,
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
