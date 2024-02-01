import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:starting_block/constants/constants.dart';
import 'package:starting_block/constants/widgets/oncampus_filter/model/onca_filter_model.dart';

class OnCaResetButton extends StatelessWidget {
  const OnCaResetButton({super.key});

  @override
  Widget build(BuildContext context) {
    // OnCaFilterModel에서 현재 선택된 프로그램을 가져옴
    final onCaFilterModel = Provider.of<OnCaFilterModel>(context);
    // 선택된 프로그램이 '전체'가 아닐 때 resetIsActive를 true로 설정
    bool resetIsActive = onCaFilterModel.selectedProgram != '전체';

    return GestureDetector(
      onTap: () {
        if (resetIsActive) {
          // OnCaFilterModel에 접근하여 resetProgram 메서드 호출
          Provider.of<OnCaFilterModel>(context, listen: false).resetProgram();
        }
      },
      child: Container(
        height: 32,
        decoration: BoxDecoration(
          color: resetIsActive ? AppColors.g1 : AppColors.white,
          borderRadius: BorderRadius.circular(46),
          border: Border.all(
            color: resetIsActive ? AppColors.g4 : AppColors.chipsColor,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Gaps.h12,
            Text(
              '초기화',
              style: AppTextStyles.btn2.copyWith(
                color: AppColors.g5,
              ),
            ),
            Gaps.h4,
            AppIcon.re,
            Gaps.h8,
          ],
        ),
      ),
    );
  }
}
