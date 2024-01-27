import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class OnCampusCardLarge extends StatefulWidget {
  const OnCampusCardLarge({
    super.key,
  });

  @override
  State<OnCampusCardLarge> createState() => _OnCampusCardLargeState();
}

class _OnCampusCardLargeState extends State<OnCampusCardLarge> {
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
          height: 104,
          decoration: BoxDecoration(
            color: isPressed ? AppColors.oncampusLargePressed : AppColors.blue,
            borderRadius: const BorderRadius.all(
              Radius.circular(4),
            ),
          ),
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
                      style: AppTextStyles.st2.copyWith(color: AppColors.white),
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
                    color: AppColors.oncampusDeepBlue,
                    borderRadius: BorderRadius.circular(37),
                  ),
                  child: Transform.translate(
                    offset: const Offset(0, 19),
                    child: Image(
                      image: AppImages.onschool_notice,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
