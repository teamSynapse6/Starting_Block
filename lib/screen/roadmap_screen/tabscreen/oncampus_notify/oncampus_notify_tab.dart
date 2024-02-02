import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/api/oncampus_manage.dart';
import 'package:starting_block/screen/manage/model_manage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:provider/provider.dart';

class TabScreenOnCaNotify extends StatefulWidget {
  final String thisSelectedText;
  final bool thisCurrentStage;

  const TabScreenOnCaNotify({
    super.key,
    required this.thisSelectedText,
    required this.thisCurrentStage,
  });

  @override
  State<TabScreenOnCaNotify> createState() => _TabScreenOnCaNotifyState();
}

class _TabScreenOnCaNotifyState extends State<TabScreenOnCaNotify> {
  List<OnCampusNotifyModel> filteredItems = [];

  @override
  void initState() {
    super.initState();
    _loadAndMatchItems();
  }

  Future<void> _loadAndMatchItems() async {
    List<OnCampusNotifyModel> allItems = await OnCampusAPI.getOnCampusNotify();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedItemsString = prefs.getString(widget.thisSelectedText);

    if (savedItemsString != null) {
      List<dynamic> savedItemsDynamic = json.decode(savedItemsString);
      List<String> savedIds =
          savedItemsDynamic.map((item) => item['id'].toString()).toList();

      setState(() {
        filteredItems = allItems
            .where((item) =>
                savedIds.contains(item.id) && item.classification == '교내사업')
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryBG,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gaps.v24,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Text("추천 사업",
                          style: AppTextStyles.st2
                              .copyWith(color: AppColors.blue)),
                      Text("이 도착했습니다",
                          style:
                              AppTextStyles.st2.copyWith(color: AppColors.g6)),
                    ],
                  ),
                ),
                Gaps.v16,
                Container(
                  height: 148,
                  width: 300,
                  color: AppColors.bluedark,
                ),
                Gaps.v24,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '저장한 사업으로 도약하기',
                        style: AppTextStyles.st2.copyWith(color: AppColors.g6),
                      ),
                      Gaps.v4,
                      Text(
                        '신청 완료한 사업은 도약 완료 버튼으로 진행도 확인하기',
                        style:
                            AppTextStyles.caption.copyWith(color: AppColors.g5),
                      ),
                    ],
                  ),
                ),
                Gaps.v20,
              ],
            ),
          )
        ],
      ),
    );
  }
}
