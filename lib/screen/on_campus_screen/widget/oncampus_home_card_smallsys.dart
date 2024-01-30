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
            builder: (context) => const OnCampusSystem(),
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
                ? AppColors.oncampusSmallSysPressed
                : AppColors.oncampusSmallSys,
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
                      '창업 제도',
                      style: AppTextStyles.bd3.copyWith(color: AppColors.white),
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
    );
  }
}
