import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/model_manage.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _nickName = '';

  @override
  void initState() {
    super.initState();
    _loadNickName(); // 닉네임 불러오기
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
      backgroundColor: AppColors.g1,
      appBar: const HomeAppBar(
        newAlarm: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gaps.v32,
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 110,
                child: Stack(
                  children: [
                    Positioned(
                      left: 10,
                      top: 12,
                      child: Text(
                        '오늘도\n도약을 위한 한걸음',
                        style: AppTextStyles.st1.copyWith(
                          color: AppColors.bluedark,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: AppIcon.character_main,
                    )
                  ],
                ),
              ),
              HomeQuestionStep(
                thisStage: 1,
                thisUserName: _nickName,
              ),
              Gaps.v28,
              const HomeNotifyRecommend(),
              Gaps.v28,
              const HomeQuestionRecommend(),
              Gaps.v44,
            ],
          ),
        ),
      ),
    );
  }
}
