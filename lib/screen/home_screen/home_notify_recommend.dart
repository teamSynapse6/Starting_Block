import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/api/home_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';
import 'package:starting_block/manage/screen_manage.dart';

class HomeNotifyRecommend extends StatefulWidget {
  const HomeNotifyRecommend({super.key});

  @override
  State<HomeNotifyRecommend> createState() => _HomeNotifyRecommendState();
}

class _HomeNotifyRecommendState extends State<HomeNotifyRecommend> {
  List<HomeAnnouncementRecModel> notifyList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAnnouncementRecommend();
  }

  void loadAnnouncementRecommend() async {
    try {
      List<HomeAnnouncementRecModel> list =
          await HomeApi.getAnnouncementRecommend();
      setState(() {
        notifyList = list;
        isLoading = false;
      });
    } catch (e) {
      // 예외 발생 시 오류 메시지 출력
    }
  }

  void thisOnTap({
    required String thisAnnouncementType,
    required String detailUrl,
    required int announcementId,
  }) {
    if (thisAnnouncementType == '교외') {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                OffCampusDetail(thisID: announcementId.toString())),
      );
    } else if (thisAnnouncementType == '교내') {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => OncampusWebViewScreen(
                  url: detailUrl, id: announcementId.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const HomeNotifySkeleton();
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '맞춤 지원 사업이 도착했어요',
            style: AppTextStyles.bd1.copyWith(color: AppColors.black),
          ),
          Gaps.v16,
          const CustomDividerH1G1(),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: notifyList.length,
            itemBuilder: (context, index) {
              HomeAnnouncementRecModel item = notifyList[index];
              return Column(
                children: [
                  Gaps.v20,
                  HomeNotifyRecommendList(
                    thisOrganize: item.keyword,
                    thisTitle: item.title,
                    thisDday: item.dday,
                    thisAnnouncementType: item.announcementType,
                    thisTap: () => thisOnTap(
                      thisAnnouncementType: item.announcementType,
                      detailUrl: item.detailUrl,
                      announcementId: item.announcementId,
                    ),
                  ),
                  if (index != notifyList.length - 1) Gaps.v20,
                  if (index != notifyList.length - 1) const CustomDividerH1G1(),
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
