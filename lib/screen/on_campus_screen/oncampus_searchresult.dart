import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/constants/widgets/oncampus_filter/model/onca_sorting_textbuttonsheet.dart';
import 'package:starting_block/manage/model_manage.dart';
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
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.searchWord;
    recentSearchManager.addSearch(widget.searchWord);
    _fetchOnCampusSearchResults();
  }

  Future<void> _fetchOnCampusSearchResults() async {
    // String selectedProgram = OnCaFilterModel().selectedProgram;
    // String selectedSorting = OnCaFilterModel().selectedSorting;

    // try {
    //   List<OffCampusModel> offcampusList =
    //       await OffCampusApi.getOffCampusSearch(
    //     supporttype: supporttype,
    //     region: region,
    //     posttarget: posttarget,
    //     sorting: sorting,
    //     keyword: widget.searchWord,
    //   );
    //   setState(() {
    //     _offcampusList = offcampusList;
    //   });
    // } catch (e) {
    //   setState(() {});
    //   // 에러 처리 로직
    // }
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
            MaterialPageRoute(builder: (context) => const OnCampusSearch()),
            (Route<dynamic> route) => false,
          );
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
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
                        '개의 공고',
                        style: AppTextStyles.bd6.copyWith(color: AppColors.g4),
                      ),
                      const Spacer(),
                      const OnCampusSortingButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          !isLoading
              ? const Expanded(
                  child: OncaSkeletonSearch(),
                )
              : Container(),
          // Expanded(
          //   child: Consumer<FilterModel>(
          //     builder: (context, filterModel, child) {
          //       if (filterModel.hasChanged) {
          //         _fetchOnCampusSearchResults().then((_) {
          //           filterModel.resetChangeFlag();
          //         });
          //       }
          //       return ListView.builder(
          //         padding: const EdgeInsets.symmetric(horizontal: 24),
          //         itemCount: _offcampusList.length,
          //         itemBuilder: (context, index) {
          //           final item = _offcampusList[index];
          //           return ItemList(
          //             thisID: item.id,
          //             thisOrganize: item.organize,
          //             thisTitle: item.title,
          //             thisStartDate: item.startDate,
          //             thisEndDate: item.endDate,
          //             thisClassification: item.classification,
          //           );
          //         },
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
