import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:starting_block/constants/constants.dart';

class OnCaSystemCard extends StatefulWidget {
  final String thisTitle, thisId, thisContent, thisTarget;
  final bool isSaved;

  const OnCaSystemCard({
    super.key,
    required this.thisTitle,
    required this.thisId,
    required this.thisContent,
    required this.thisTarget,
    required this.isSaved,
  });

  @override
  State<OnCaSystemCard> createState() => _OnCaSystemCardState();
}

class _OnCaSystemCardState extends State<OnCaSystemCard> {
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
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          color: AppColors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.thisTitle,
                      style: AppTextStyles.bd1.copyWith(color: AppColors.g6),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Gaps.h15,
                  BookMarkButton(
                    isSaved: widget.isSaved,
                    thisID: widget.thisId,
                  ),
                ],
              ),
              Gaps.v10,
              const CustomDivider(),
              Gaps.v10,
              if (widget.thisTarget.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '지원 대상',
                      style: AppTextStyles.bd5.copyWith(color: AppColors.g4),
                    ),
                    Gaps.v4,
                    Text(
                      widget.thisTarget,
                      maxLines: _isExpanded ? null : 2,
                      overflow: _isExpanded ? null : TextOverflow.ellipsis,
                      style: AppTextStyles.bd4.copyWith(color: AppColors.g6),
                    ),
                    Gaps.v10,
                  ],
                ),
              if (widget.thisContent.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '내용',
                      style: AppTextStyles.bd5.copyWith(color: AppColors.g4),
                    ),
                    Gaps.v4,
                    Text(
                      widget.thisContent,
                      maxLines: _isExpanded ? null : 2,
                      overflow: _isExpanded ? null : TextOverflow.ellipsis,
                      style: AppTextStyles.bd4.copyWith(color: AppColors.g6),
                    ),
                    Gaps.v10,
                    if (_isExpandable)
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
                                _isExpanded ? '접기' : '더보기',
                                style: AppTextStyles.btn2
                                    .copyWith(color: AppColors.g4),
                              ),
                              Gaps.h4,
                              _isExpanded
                                  ? AppIcon.arrow_up_16
                                  : AppIcon.arrow_down_16,
                            ],
                          ),
                        ),
                      ),
                  ],
                )
            ],
          ),
        );
      },
    );
  }
}
