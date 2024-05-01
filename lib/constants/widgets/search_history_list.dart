import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class SearchHistoryList extends StatelessWidget {
  final String thisText;
  final VoidCallback thisTap, thisDeleteTap;

  const SearchHistoryList({
    super.key,
    required this.thisText,
    required this.thisTap,
    required this.thisDeleteTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: thisTap,
      child: Ink(
        height: 56,
        color: AppColors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Text(
                thisText,
                style: AppTextStyles.bd2.copyWith(color: AppColors.g6),
              ),
              const Spacer(),
              GestureDetector(
                onTap: thisDeleteTap,
                child: AppIcon.close,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
