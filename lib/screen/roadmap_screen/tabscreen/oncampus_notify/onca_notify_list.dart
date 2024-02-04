import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/screen/manage/screen_manage.dart';

class OnCaListNotify extends StatelessWidget {
  final String thisProgramType, thisID, thisClassification, thisTitle, thisUrl;

  const OnCaListNotify({
    super.key,
    required this.thisProgramType,
    required this.thisID,
    required this.thisClassification,
    required this.thisTitle,
    required this.thisUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WebViewScreen(
              url: thisUrl,
              id: thisID,
            ),
          ),
        );
      },
      child: Container(
        width: 312,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  OrganizeChip(
                    text: thisProgramType,
                  ),
                  const Spacer(),
                  BookMarkButton(
                    id: thisID,
                    classification: thisClassification,
                  ),
                ],
              ),
              Gaps.v10,
              Text(
                thisTitle,
                style: AppTextStyles.bd2.copyWith(color: AppColors.g6),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Gaps.v4,
            ],
          ),
        ),
      ),
    );
  }
}
