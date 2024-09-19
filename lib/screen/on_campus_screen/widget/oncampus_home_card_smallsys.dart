import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/screen_manage.dart';

class OnCampusCardSmallSystem extends StatefulWidget {
  const OnCampusCardSmallSystem({
    super.key,
  });

  @override
  State<OnCampusCardSmallSystem> createState() =>
      _OnCampusCardSmallSystemState();
}

class _OnCampusCardSmallSystemState extends State<OnCampusCardSmallSystem> {
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
                colors: [Color(0xffDBB7FF), Color(0xffE8D1FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const OnCampusSystem(),
                ),
              );
            },
            borderRadius: const BorderRadius.all(
              Radius.circular(4),
            ),
            splashColor: const Color(0xffCB98FF),
            highlightColor: const Color(0xffCB98FF),
            child: Stack(
              children: [
                Positioned(
                  left: 8,
                  top: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '제도',
                        style:
                            AppTextStyles.bd3.copyWith(color: AppColors.white),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 8,
                  bottom: 12,
                  child: AppIcon.onschool_system,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
