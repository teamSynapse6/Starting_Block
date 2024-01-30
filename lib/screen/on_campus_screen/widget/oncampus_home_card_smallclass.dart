import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';

class OnCampusCardSmallClass extends StatefulWidget {
  const OnCampusCardSmallClass({
    super.key,
  });

  @override
  State<OnCampusCardSmallClass> createState() => _OnCampusCardSmallClassState();
}

class _OnCampusCardSmallClassState extends State<OnCampusCardSmallClass> {
  bool isPressed = false;

  void _handlePress(bool pressed) {
    setState(() {
      isPressed = pressed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const OnCampusClass(),
          ),
        );
      },
      onLongPressStart: (details) => _handlePress(true),
      onLongPressEnd: (details) => _handlePress(false),
      child: FractionallySizedBox(
        widthFactor: 1,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          height: 88,
          decoration: BoxDecoration(
            color: isPressed
                ? AppColors.oncampusSmallClassPressed
                : AppColors.bluelight,
            borderRadius: const BorderRadius.all(
              Radius.circular(4),
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 8,
                top: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '창업 강의',
                      style: AppTextStyles.bd3.copyWith(color: AppColors.white),
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
    );
  }
}
