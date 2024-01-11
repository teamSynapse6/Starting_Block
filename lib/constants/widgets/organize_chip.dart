import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class OrganizeChip extends StatelessWidget {
  final String text;

  const OrganizeChip({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: 24,
      decoration: const BoxDecoration(
        color: Color(0XffE8EDF5),
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
      child: Center(
        child: Text(
          text,
          style: AppTextStyles.caption.copyWith(color: AppColors.g5),
        ),
      ),
    );
  }
}
