import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class OnCaListClass extends StatefulWidget {
  final String thisTitle,
      thisId,
      thisLiberal,
      thisCredit,
      thisContent,
      thisTeacher,
      thisSession;
  final bool thisBookMaekSaved;

  const OnCaListClass({
    super.key,
    required this.thisTitle,
    required this.thisId,
    required this.thisLiberal,
    required this.thisCredit,
    required this.thisContent,
    required this.thisSession,
    required this.thisTeacher,
    required this.thisBookMaekSaved,
  });

  @override
  State<OnCaListClass> createState() => _OnCaListClassState();
}

class _OnCaListClassState extends State<OnCaListClass> {
  bool _isExpanded = false; // 콘텐츠 확장 상태를 관리할 변수

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                widget.thisTitle,
                style: AppTextStyles.bd1.copyWith(color: AppColors.black),
              ),
              const Spacer(),
              BookMarkLectureButton(
                  isSaved: widget.thisBookMaekSaved,
                  thisLectureID: widget.thisId)
            ],
          ),
          Gaps.v20,
          const CustomDivider(),
          Gaps.v12,
          Row(
            children: [
              ClassLiberalChips(thisText: widget.thisLiberal),
              Gaps.h8,
              ClassCreditsChips(thisTextNum: widget.thisCredit),
              Gaps.h8,
              ClassSessionChips(thisTextSession: widget.thisSession),
            ],
          ),
          Gaps.v12,
          Text(
            '교강사',
            style: AppTextStyles.bd5.copyWith(color: AppColors.g4),
          ),
          Gaps.v2,
          Text(
            widget.thisTeacher,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.bd4.copyWith(color: AppColors.g6),
          ),
          Gaps.v12,
          Text(
            '강의 개요',
            style: AppTextStyles.bd5.copyWith(color: AppColors.g4),
          ),
          Gaps.v2,
          Text(
            widget.thisContent,
            maxLines: _isExpanded ? null : 2,
            overflow:
                _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            style: AppTextStyles.bd4.copyWith(color: AppColors.g6),
          ),
          Gaps.v10,
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded; // 확장 상태를 토글
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '더보기',
                  style: AppTextStyles.btn2.copyWith(color: AppColors.g4),
                ),
                Gaps.h4,
                _isExpanded ? AppIcon.arrow_up_18 : AppIcon.arrow_down_18,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
