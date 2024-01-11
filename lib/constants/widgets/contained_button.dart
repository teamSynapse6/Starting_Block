import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class NextContained extends StatelessWidget {
  const NextContained({
    super.key,
    required this.disabled,
    required this.text,
  });

  final bool disabled;
  final String text; //우리가 form을 받을 때 _uername이 비어있으면 disabled로 반환해라

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: AnimatedContainer(
        height: Sizes.size48,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: disabled ? AppColors.g2 : AppColors.blue),
        duration: const Duration(milliseconds: 50),
        child: Center(
          child: AnimatedDefaultTextStyle(
            style: TextStyle(
              color: Colors.white, // 텍스트 색상을 하얀색으로 설정
              fontSize:
                  AppTextStyles.btn1.fontSize, // AppTextStyles.btn1의 글꼴 크기 적용
              fontWeight:
                  AppTextStyles.btn1.fontWeight, // AppTextStyles.btn1의 글꼴 두께 적용
            ),
            duration: const Duration(milliseconds: 50),
            child: Text(
              text,
              style: AppTextStyles.btn1,
            ),
          ),
        ),
      ),
    );
  }
}
