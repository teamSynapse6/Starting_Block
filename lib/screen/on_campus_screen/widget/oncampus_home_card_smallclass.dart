import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/manage/screen_manage.dart';

class OnCampusCardSmallClass extends StatefulWidget {
  const OnCampusCardSmallClass({
    super.key,
  });

  @override
  State<OnCampusCardSmallClass> createState() => _OnCampusCardSmallClassState();
}

class _OnCampusCardSmallClassState extends State<OnCampusCardSmallClass> {
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
                colors: [Color(0xffB1C5F6), Color(0xffC8D6F9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const OnCampusClass(),
                ),
              );
            },
            splashColor: const Color(0xff95B4FF),
            highlightColor: const Color(0xff95B4FF),
            borderRadius: BorderRadius.circular(4),
            child: Stack(
              children: [
                Positioned(
                  left: 8,
                  top: 12,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '강의',
                        style:
                            AppTextStyles.bd3.copyWith(color: AppColors.white),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 8,
                  bottom: 12,
                  child: AppIcon.onschool_class,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
