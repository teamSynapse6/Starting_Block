import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class ScrollToTopButton extends StatelessWidget {
  final VoidCallback thisBackToTopTap;

  const ScrollToTopButton({
    super.key,
    required this.thisBackToTopTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: thisBackToTopTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.black.withOpacity(0.5),
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.25),
                spreadRadius: 0,
                blurRadius: 4,
                offset: const Offset(0, 4),
              )
            ]),
        child: Center(
          child: AppIcon.arrow_up_24,
        ),
      ),
    );
  }
}
