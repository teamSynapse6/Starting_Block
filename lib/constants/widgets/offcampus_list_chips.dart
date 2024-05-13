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
    String displayText =
        text.length > 16 ? '${text.substring(0, 13)}...' : text;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 3,
      ),
      decoration: const BoxDecoration(
        color: AppColors.g1,
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
      child: Center(
        child: Text(
          displayText,
          style: AppTextStyles.caption.copyWith(color: AppColors.g5),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    );
  }
}

class OrganizeChipForOfca extends StatelessWidget {
  final String text;

  const OrganizeChipForOfca({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    String displayText =
        text.length > 16 ? '${text.substring(0, 13)}...' : text;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 3,
      ),
      decoration: const BoxDecoration(
        color: AppColors.g1,
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
      child: Center(
        child: Text(
          displayText,
          style: AppTextStyles.caption.copyWith(color: AppColors.g5),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    );
  }
}

class ConatactChip extends StatelessWidget {
  const ConatactChip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 3,
      ),
      decoration: const BoxDecoration(
        color: AppColors.bluebg,
        borderRadius: BorderRadius.all(Radius.circular(2)),
      ),
      child: Center(
        child: Text(
          '문의처 질문',
          style: AppTextStyles.caption.copyWith(color: AppColors.blue),
        ),
      ),
    );
  }
}

class AIChip extends StatelessWidget {
  const AIChip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFFF6B0A).withOpacity(0.1),
        borderRadius: const BorderRadius.all(Radius.circular(2)),
      ),
      child: Center(
        child: Text(
          'AI 분석',
          style: AppTextStyles.caption.copyWith(color: AppColors.salmon),
        ),
      ),
    );
  }
}
