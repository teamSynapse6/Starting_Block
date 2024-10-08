import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:starting_block/constants/constants.dart';

class OnCaClassCard extends StatefulWidget {
  final String thisTitle,
      thisId,
      thisLiberal,
      thisCredit,
      thisContent,
      thisInstructor,
      thisSession;
  final bool isSaved;

  const OnCaClassCard({
    super.key,
    required this.thisTitle,
    required this.thisId,
    required this.thisLiberal,
    required this.thisCredit,
    required this.thisContent,
    required this.thisSession,
    required this.thisInstructor,
    required this.isSaved,
  });

  @override
  State<OnCaClassCard> createState() => _OnCaClassCardState();
}

class _OnCaClassCardState extends State<OnCaClassCard> {
  bool _isExpanded = false;
  bool _isExpandable = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // TextPainter를 사용하여 실제 텍스트 높이 계산
        final textPainter = TextPainter(
          text: TextSpan(
              text: widget.thisContent,
              style: AppTextStyles.bd4.copyWith(color: AppColors.g6)),
          maxLines: 2,
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: constraints.maxWidth);

        // 최대 두 줄의 높이와 실제 텍스트 높이를 비교하여 _isExpandable 결정
        if (textPainter.didExceedMaxLines) {
          _isExpandable = true;
        } else {
          _isExpandable = false;
          _isExpanded = false; // 내용이 두 줄을 넘지 않으면 접힌 상태로 유지
        }

        return Container(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
          color: AppColors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.thisTitle,
                      style: AppTextStyles.bd1.copyWith(color: AppColors.black),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Gaps.h15,
                  BookMarkLectureButton(
                    isSaved: widget.isSaved,
                    thisLectureID: widget.thisId,
                  ),
                ],
              ),
              Gaps.v12,
              const CustomDivider(),
              Gaps.v16,
              Row(
                children: [
                  if (widget.thisLiberal.isNotEmpty)
                    Row(
                      children: [
                        ClassLiberalChips(thisText: widget.thisLiberal),
                        Gaps.h8,
                      ],
                    ),
                  if (widget.thisCredit != '0')
                    Row(
                      children: [
                        ClassCreditsChips(thisTextNum: widget.thisCredit),
                        Gaps.h8,
                      ],
                    ),
                  if (widget.thisSession.isNotEmpty)
                    ClassSessionChips(thisTextSession: widget.thisSession),
                ],
              ),
              Gaps.v12,
              if (widget.thisInstructor.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '교강사',
                      style: AppTextStyles.bd5.copyWith(color: AppColors.g4),
                    ),
                    Gaps.v2,
                    Text(
                      widget.thisInstructor,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bd4.copyWith(color: AppColors.g6),
                    ),
                    Gaps.v12,
                  ],
                ),
              if (widget.thisContent.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '강의 개요',
                      style: AppTextStyles.bd5.copyWith(color: AppColors.g4),
                    ),
                    Gaps.v2,
                    Text(
                      widget.thisContent,
                      maxLines: _isExpanded ? null : 2,
                      overflow: _isExpanded ? null : TextOverflow.ellipsis,
                      style: AppTextStyles.bd4.copyWith(color: AppColors.g6),
                    ),
                    Gaps.v4,
                  ],
                ),
              if (_isExpandable)
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: SizedBox(
                    height: 36,
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          _isExpanded ? '접기' : '더보기',
                          style:
                              AppTextStyles.btn2.copyWith(color: AppColors.g4),
                        ),
                        Gaps.h4,
                        _isExpanded
                            ? AppIcon.arrow_up_18
                            : AppIcon.arrow_down_18
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
