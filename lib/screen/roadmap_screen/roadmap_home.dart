import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';

class RoadmapHome extends StatefulWidget {
  const RoadmapHome({super.key});

  @override
  State<RoadmapHome> createState() => _RoadmapHomeState();
}

class _RoadmapHomeState extends State<RoadmapHome> {
  String _nickName = "";

  @override
  void initState() {
    super.initState();
    _loadNickName();
  }

  Future<void> _loadNickName() async {
    String nickName = await UserInfo.getNickName();
    setState(() {
      _nickName = nickName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: Container(
          color: AppColors.blue,
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              height: 152,
              width: MediaQuery.of(context).size.width,
              color: AppColors.blue,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Gaps.v36,
                    Text(
                      '$_nickName님의 현재 단계는',
                      style: AppTextStyles.bd6.copyWith(color: AppColors.white),
                    ),
                    Gaps.v4,
                    const RoadMapList(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
