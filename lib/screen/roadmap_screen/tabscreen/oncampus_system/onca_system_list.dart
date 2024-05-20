import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:starting_block/constants/constants.dart';

class OnCaListSystem extends StatefulWidget {
  final String thisTitle, thisId, thisContent, thisTarget;
  final bool isSaved;

  const OnCaListSystem({
    super.key,
    required this.thisTitle,
    required this.thisId,
    required this.thisContent,
    required this.thisTarget,
    required this.isSaved,
  });

  @override
  State<OnCaListSystem> createState() => _OnCaListSystemState();
}

class _OnCaListSystemState extends State<OnCaListSystem> {
  bool _isExpanded = false; // 콘텐츠 확장 상태를 관리할 변수

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.thisTitle,
                  style: AppTextStyles.bd1.copyWith(color: AppColors.g6),
                ),
              ),
              BookMarkButton(
                isSaved: widget.isSaved,
                thisID: widget.thisId,
              )
            ],
          ),
          Gaps.v10,
          const CustomDivider(),
          Gaps.v10,
          Text(
            '지원 대상',
            style: AppTextStyles.bd5.copyWith(color: AppColors.g4),
          ),
          Gaps.v4,
          Text(
            widget.thisTarget,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bd4.copyWith(color: AppColors.g6),
          ),
          Gaps.v10,
          Text(
            '내용',
            style: AppTextStyles.bd5.copyWith(color: AppColors.g4),
          ),
          Gaps.v4,
          Text(
            widget.thisContent,
            maxLines: _isExpanded ? null : 2,
            overflow:
                _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            style: AppTextStyles.bd4.copyWith(color: AppColors.g6),
          ),
          Gaps.v8,
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded; // 확장 상태를 토글
              });
            },
            child: SizedBox(
              height: 36,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '더보기',
                    style: AppTextStyles.btn2.copyWith(color: AppColors.g4),
                  ),
                  Gaps.h4,
                  _isExpanded ? AppIcon.arrow_up_16 : AppIcon.arrow_down_16,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
