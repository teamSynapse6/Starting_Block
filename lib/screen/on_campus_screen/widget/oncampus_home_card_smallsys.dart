import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';

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
              color: AppColors.oncampusSmallSys),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const OnCampusSystem(),
                ),
              );
            },
            splashColor: AppColors.oncampusSmallSysPressed,
            highlightColor: AppColors.oncampusSmallSysPressed,
            child: Stack(
              children: [
                Positioned(
                  left: 8,
                  top: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '창업 제도',
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
