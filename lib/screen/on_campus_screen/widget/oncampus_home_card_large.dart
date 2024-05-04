import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/screen_manage.dart';

class OnCampusCardLarge extends StatefulWidget {
  const OnCampusCardLarge({
    super.key,
  });

  @override
  State<OnCampusCardLarge> createState() => _OnCampusCardLargeState();
}

class _OnCampusCardLargeState extends State<OnCampusCardLarge> {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: Material(
        color: Colors.transparent, // Material의 기본 배경색을 투명하게 설정
        child: Ink(
          height: 104,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(4),
            ),
            gradient: LinearGradient(
              colors: [Color(0XFF5E8BFF), Color(0XFF8FAEFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const OnCampusNotify(),
                ),
              );
            },
            splashColor: AppColors.blue,
            highlightColor: AppColors.blue,
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              children: [
                Positioned(
                  left: 12,
                  top: 29,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "창업 지원 공고",
                        style:
                            AppTextStyles.st2.copyWith(color: AppColors.white),
                      ),
                      Gaps.v4,
                      Text(
                        "비교과 지원 확인!",
                        style: AppTextStyles.bd6.copyWith(color: AppColors.g2),
                      )
                    ],
                  ),
                ),
                Positioned(
                  right: 12,
                  top: 15,
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    height: 74,
                    width: 74,
                    decoration: BoxDecoration(
                      color: AppColors.blue,
                      borderRadius: BorderRadius.circular(37),
                    ),
                    child: Transform.translate(
                        offset: const Offset(0, 19),
                        child: AppIcon.onschool_notice),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
