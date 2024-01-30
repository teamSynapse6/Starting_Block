import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class ClassLiberalChips extends StatelessWidget {
  final String thisText;

  const ClassLiberalChips({
    super.key,
    required this.thisText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: AppColors.white,
        border: Border.all(
          color: AppColors.blue,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 4,
        ),
        child: Center(
          child: Text(
            thisText,
            style: AppTextStyles.btn2.copyWith(color: AppColors.blue),
          ),
        ),
      ),
    );
  }
}

class ClassCreditsChips extends StatelessWidget {
  final String thisTextNum;

  const ClassCreditsChips({
    super.key,
    required this.thisTextNum,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: AppColors.white,
        border: Border.all(
          color: AppColors.blue,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 4,
        ),
        child: Center(
          child: Text(
            '$thisTextNum학점',
            style: AppTextStyles.btn2.copyWith(color: AppColors.blue),
          ),
        ),
      ),
    );
  }
}

class ClassSessionChips extends StatelessWidget {
  final String thisTextSession;

  const ClassSessionChips({
    super.key,
    required this.thisTextSession,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: AppColors.g1,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 4,
        ),
        child: Center(
          child: Text(
            thisTextSession,
            style: AppTextStyles.btn2.copyWith(color: AppColors.g4),
          ),
        ),
      ),
    );
  }
}
