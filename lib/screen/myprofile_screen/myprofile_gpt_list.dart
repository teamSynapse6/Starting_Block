import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:starting_block/constants/constants.dart';

class MyProfileGptList extends StatefulWidget {
  const MyProfileGptList({super.key});

  @override
  State<MyProfileGptList> createState() => _MyProfileGptListState();
}

class _MyProfileGptListState extends State<MyProfileGptList> {
  Color topColor = const Color(0xff5E8BFF);
  Color bottomColor = const Color(0xff00288F);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            topColor,
            bottomColor,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const BackTitleAppBarForGptList(),
        body: Column(
          children: [
            Gaps.v16,
            Row(
              children: [
                Gaps.h24,
                AppIcon.gpt_robot_icon,
                Gaps.h14,
                Column(
                  children: [Gaps.v25, AppIcon.gpt_listpage_tail],
                ),
                Container(
                  width: 220,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 6,
                  ),
                  color: AppColors.bluebg.withOpacity(0.8),
                  child: const Text(
                    '공고의 첨부파일을 학습하여\n창업자님의 질문에 답변을 드려요!',
                    style: TextStyle(
                        color: AppColors.g6,
                        fontFamily: 'pretendard',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        height: 16 / 12),
                  ),
                )
              ],
            ),
            Gaps.v24,
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: const Column(
                  children: [
                    Gaps.v12,
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
