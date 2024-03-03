import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class OfcaOncaChip extends StatelessWidget {
  final bool isOfca;

  const OfcaOncaChip({
    super.key,
    required this.isOfca,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      height: 24,
      decoration: BoxDecoration(
        color: isOfca ? AppColors.salmon.withOpacity(0.1) : AppColors.bluebg,
        borderRadius: const BorderRadius.all(Radius.circular(2)),
      ),
      child: Center(
        child: Text(
          isOfca ? '교외' : '교내',
          style: AppTextStyles.caption
              .copyWith(color: isOfca ? AppColors.salmon : AppColors.blue),
        ),
      ),
    );
  }
}
