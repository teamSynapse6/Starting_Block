// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/screen_manage.dart';

class OnCampusCardMedium extends StatefulWidget {
  const OnCampusCardMedium({
    super.key,
  });

  @override
  State<OnCampusCardMedium> createState() => _OnCampusCardMediumState();
}

class _OnCampusCardMediumState extends State<OnCampusCardMedium> {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Material(
        color: Colors.transparent, // Material의 기본 배경색을 투명하게 설정
        child: Ink(
          height: 88,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(4),
            ),
            gradient: LinearGradient(
              colors: [Color(0XFFFDA86A), Color(0XFFFDB681)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const OnCampusSupportGroup(),
                ),
              );
            },
            splashColor: const Color(0xffFF994F),
            highlightColor: const Color(0xffFF994F),
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              children: [
                Positioned(
                  left: 12,
                  top: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "창업지원단",
                        style:
                            AppTextStyles.bd1.copyWith(color: AppColors.white),
                      ),
                      Text(
                        "비교과 지원 확인!",
                        style: AppTextStyles.bd6.copyWith(color: AppColors.g1),
                      )
                    ],
                  ),
                ),
                Positioned(
                    right: 11,
                    bottom: 12,
                    child: AppIcon.onschool_supportgroup),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
