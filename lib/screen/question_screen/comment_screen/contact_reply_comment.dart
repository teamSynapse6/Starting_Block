import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:starting_block/constants/constants.dart';

class QuestionContactComment extends StatelessWidget {
  const QuestionContactComment({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '문의처 답장이 있어요',
            style: AppTextStyles.bd5.copyWith(color: AppColors.g5),
          ),
          Gaps.v16,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: AppColors.bluedark,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.g2,
                    width: 1,
                  ),
                ),
                child: AppIcon.contact_logo_18,
              ),
              Gaps.h10,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '송파구청 일자리정책담당관',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bd3.copyWith(color: AppColors.g6),
                    ),
                    Gaps.v4,
                    Text(
                      '안녕하세요. 송파구청 일자리정책담당관입니다. 문의주신 내용에 대해 답변드립니다.',
                      style: AppTextStyles.bd2.copyWith(color: AppColors.g6),
                    ),
                    Gaps.v4,
                    Text(
                      '2023.11.30',
                      style: AppTextStyles.bd6.copyWith(color: AppColors.g4),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Gaps.v20,
          const CustomDividerH2G1(),
        ],
      ),
    );
  }
}
