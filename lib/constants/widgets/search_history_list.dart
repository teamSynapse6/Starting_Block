import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
              Expanded(
                child: Text(
                  thisText,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bd2.copyWith(color: AppColors.g6),
                ),
              ),
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
