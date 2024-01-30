// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class OnCampusCardMedium extends StatefulWidget {
  const OnCampusCardMedium({
    super.key,
  });

  @override
  State<OnCampusCardMedium> createState() => _OnCampusCardMediumState();
}

class _OnCampusCardMediumState extends State<OnCampusCardMedium> {
  bool isPressed = false;

  void _handlePress(bool pressed) {
    setState(() {
      isPressed = pressed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: null,
      onLongPressStart: (details) => _handlePress(true),
      onLongPressEnd: (details) => _handlePress(false),
      child: FractionallySizedBox(
        widthFactor: 1,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          height: 88,
          decoration: BoxDecoration(
            color: isPressed
                ? AppColors.oncampusMediumPressed
                : AppColors.oncampusMedium,
            borderRadius: const BorderRadius.all(
              Radius.circular(4),
            ),
          ),
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
                      style: AppTextStyles.bd1.copyWith(color: AppColors.white),
                    ),
                    Text(
                      "비교과 지원 확인!",
                      style: AppTextStyles.bd6.copyWith(color: AppColors.g1),
                    )
                  ],
                ),
              ),
              Positioned(
                  right: 11, bottom: 12, child: AppIcon.onschool_supportgroup),
            ],
          ),
        ),
      ),
    );
  }
}
