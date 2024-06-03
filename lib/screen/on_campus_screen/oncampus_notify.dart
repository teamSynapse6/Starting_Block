import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/constants/widgets/oncampus_filter/model/onca_sorting_textbuttonsheet.dart';
import 'package:starting_block/manage/api/oncampus_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';
import 'package:starting_block/screen/on_campus_screen/widget/oncampus_notify_delegate.dart';

class OnCampusNotify extends StatefulWidget {
  final bool hasNotifyData;

  const OnCampusNotify({
    super.key,
    required this.hasNotifyData,
  });

  @override
  State<OnCampusNotify> createState() => _OnCampusNotifyState();
}

class _OnCampusNotifyState extends State<OnCampusNotify> {
  List<OncaAnnouncementModel> _notifyList = [];
  bool isLoading = true;
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  String _userNickName = '';

  String _selectedProgram = '';
  // String _selectedSorting = '';

  @override
  void initState() {
    super.initState();
    loadFilterValue();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose(); // 위젯 사용이 끝날 때 컨트롤러 해제
    super.dispose();
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
      _loadFilteredOnCampusNotify();
    });
  }

  Future<void> _loadFilteredOnCampusNotify() async {
    if (!widget.hasNotifyData) {
      final nickName = await UserInfo.getNickName();
      setState(() {
        _userNickName = nickName;
      });
    }
    try {
      // API 호출
      List<OncaAnnouncementModel> notifyList =
          await OnCampusApi.getOncaAnnouncement(
        keyword: _selectedProgram,
        search: 'null',
      );

      setState(() {
        _notifyList = notifyList;
        isLoading = false;
      });
    } catch (e) {
      return;
    }
  }

  void _onScroll() {
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

  void backToTopTap() {
    _scrollController.animateTo(
      0.0, // 최상단 위치
      duration: const Duration(milliseconds: 300), // 애니메이션 지속 시간
      curve: Curves.easeOut, // 애니메이션 곡선 설정
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OnCaFilterModel>(
      builder: (context, filterModel, child) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (filterModel.hasChanged) {
            loadFilterValue();
            filterModel.resetChangeFlag();
          }
        });
        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: Container(
              color: AppColors.white,
            ),
          ),
          body: Consumer<BookMarkNotifier>(
              builder: (context, bookmarkNotifier, child) {
            if (bookmarkNotifier.isUpdated) {
              loadFilterValue();
              bookmarkNotifier.resetUpdate();
            }
            return Stack(
              children: [
                NestedScrollView(
                  controller: _scrollController,
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                        centerTitle: false,
                        snap: true,
                        floating: true,
                        elevation: 0,
                        forceElevated: innerBoxIsScrolled,
                        backgroundColor: AppColors.white,
                        pinned: true,
                        expandedHeight: 128,
                        collapsedHeight: 56,
                        leading: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () => Navigator.of(context).pop(),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: AppIcon.back,
                          ),
                        ),
                        actions: [
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const OnCampusSearch(),
                                  ),
                                );
                                loadFilterValue();
                              },
                              child: SizedBox(
                                height: 48,
                                width: 48,
                                child: AppIcon.search,
                              ),
                            ),
                          ),
                        ],
                        flexibleSpace: LayoutBuilder(
                          builder: (BuildContext context,
                              BoxConstraints constraints) {
                            // AppBar의 최대 높이와 현재 높이를 기준으로 패딩 값을 계산
                            double appBarHeight = constraints.biggest.height;
                            double maxPaddingTop = 20;
                            double minPaddingTop = 16;
                            double paddingTopRange =
                                maxPaddingTop - minPaddingTop;
                            double heightRange =
                                128 - 56; // expandedHeight - collapsedHeight

                            // 선형적으로 paddingBottom 계산
                            double paddingBottom = minPaddingTop +
                                paddingTopRange *
                                    ((appBarHeight - 56) / heightRange);

                            return FlexibleSpaceBar(
                              centerTitle: false,
                              expandedTitleScale: 24 / 18,
                              titlePadding: EdgeInsets.only(
                                top: 16,
                                bottom: paddingBottom,
                                left: 60,
                              ),
                              title: Text(
                                '지원 공고',
                                style: AppTextStyles.st2
                                    .copyWith(color: AppColors.g6),
                              ),
                              background: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Gaps.v80,
                                    SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: SchoolLogoWidget(),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: OnCampusNotifyDelegate(
                          child: Container(
                            color: AppColors.white,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const ProgramChipsSheet(),
                                  Gaps.v12,
                                  Container(
                                    height: 32,
                                    decoration: const BoxDecoration(
                                      border: BorderDirectional(
                                        top: BorderSide(
                                            width: 2, color: AppColors.g1),
                                        bottom: BorderSide(
                                            width: 2, color: AppColors.g1),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${_notifyList.length}개의 공고',
                                          style: AppTextStyles.bd4
                                              .copyWith(color: AppColors.g4),
                                        ),
                                        const OnCampusSortingButton()
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ];
                  },
                  body: isLoading
                      ? const OncaSkeletonNotify()
                      : widget.hasNotifyData
                          ? SingleChildScrollView(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: Column(
                                  children: [
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: _notifyList.length,
                                      itemBuilder: (context, index) {
                                        final notify = _notifyList[index];
                                        return Column(
                                          children: [
                                            OnCampusNotifyListCard(
                                              thisProgramText: notify.keyword,
                                              thisId: notify.announcementId
                                                  .toString(),
                                              thisTitle: notify.title,
                                              thisStartDate: notify.insertDate,
                                              thisUrl: notify.detailUrl,
                                              isSaved: notify.isBookmarked,
                                            ),
                                            if (index < _notifyList.length - 1)
                                              const CustomDividerH2G1(),
                                          ],
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : OnCampusEmptyDisplay(
                              userNickName: _userNickName,
                            ),
                ),
                if (_isScrolled && _notifyList.isNotEmpty)
                  Positioned(
                    right: 24,
                    bottom: 12,
                    child: ScrollToTopButton(
                      thisBackToTopTap: backToTopTap,
                    ),
                  )
              ],
            );
          }),
        );
      },
    );
  }
}
