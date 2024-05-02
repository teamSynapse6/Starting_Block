import 'package:flutter/material.dart';
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
  List<OnCampusNotifyModel> _notifyList = [];

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
    List<OnCampusNotifyModel> notifyList =
        await OnCampusAPI.getOnCampusHomeNotify();
    setState(() {
      _notifyList = notifyList;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    const OnCampusCardLarge(),
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
                          width: MediaQuery.of(context).size.width * (72 / 360),
                          child: const OnCampusCardSmallSystem(),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * (72 / 360),
                          child: const OnCampusCardSmallClass(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Gaps.v44,
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
                      thisProgramText: notifyitem.classification,
                      thisId: notifyitem.id,
                      thisTitle: notifyitem.title,
                      thisStartDate: notifyitem.startdate,
                      thisUrl: notifyitem.detailurl,
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
  }
}
