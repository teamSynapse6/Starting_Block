import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/oncampus_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';

class OnCampusHome extends StatefulWidget {
  const OnCampusHome({super.key});

  @override
  State<OnCampusHome> createState() => _OnCampusHomeState();
}

class _OnCampusHomeState extends State<OnCampusHome> {
  String _schoolName = "";
  List<OncaAnnouncementModel> _notifyList = [];

  @override
  void initState() {
    super.initState();
    _loadSchoolName();
    _loadOnCampusHomeNotify();
  }

  Future<void> _loadSchoolName() async {
    String schoolName = await UserInfo.getSchoolName();
    setState(() {
      _schoolName = schoolName;
    });
  }

  Future<void> _loadOnCampusHomeNotify() async {
    List<OncaAnnouncementModel> notifyList =
        await OnCampusApi.getOncaAnnouncement(
      keyword: 'null',
      search: 'null',
    );

    // 최신순으로 정렬 (insertDate를 기준으로 내림차순)
    notifyList.sort((a, b) => b.insertDate.compareTo(a.insertDate));

    // 상위 5개만 가져오기
    List<OncaAnnouncementModel> topFiveNotifyList = notifyList.take(5).toList();

    // 상태 업데이트
    setState(() {
      _notifyList = topFiveNotifyList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookMarkNotifier>(
        builder: (context, bookmarkNotifier, child) {
      if (bookmarkNotifier.isUpdated) {
        _loadOnCampusHomeNotify();
        bookmarkNotifier.resetUpdate();
      }
      return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0),
          child: Container(
            color: AppColors.bluebg,
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 334,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [302 / 328, 302 / 328],
                    colors: [
                      AppColors.bluebg,
                      AppColors.white,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gaps.v76,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 24,
                            width: 24,
                            child: SchoolLogoWidget(),
                          ),
                          Gaps.h4,
                          Text(
                            _schoolName,
                            style:
                                AppTextStyles.st2.copyWith(color: AppColors.g6),
                          ),
                        ],
                      ),
                      Gaps.v28,
                      OnCampusCardLarge(
                        hasNotifyData: _notifyList.isNotEmpty,
                      ),
                      Gaps.v12,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width:
                                MediaQuery.of(context).size.width * (152 / 360),
                            child: const OnCampusCardMedium(),
                          ),
                          SizedBox(
                            width:
                                MediaQuery.of(context).size.width * (72 / 360),
                            child: const OnCampusCardSmallSystem(),
                          ),
                          SizedBox(
                            width:
                                MediaQuery.of(context).size.width * (72 / 360),
                            child: const OnCampusCardSmallClass(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Gaps.v44,
              if (_notifyList.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    '최신 교내 지원 사업',
                    style: AppTextStyles.st2.copyWith(color: AppColors.g6),
                  ),
                ),
              Gaps.v8,
              ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: _notifyList.length,
                itemBuilder: (context, index) {
                  final notifyitem = _notifyList[index];
                  return Column(
                    children: [
                      OnCampusNotifyListCard(
                        thisProgramText: notifyitem.keyword,
                        thisId: notifyitem.announcementId.toString(),
                        thisTitle: notifyitem.title,
                        thisStartDate: notifyitem.insertDate,
                        thisUrl: notifyitem.detailUrl,
                        isSaved: notifyitem.isBookmarked,
                      ),
                      if (index < _notifyList.length) const CustomDividerH2G1(),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
