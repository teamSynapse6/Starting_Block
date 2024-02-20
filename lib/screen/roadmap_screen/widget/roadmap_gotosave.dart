import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class GotoSaveItem extends StatelessWidget {
  final VoidCallback tapAction;

  const GotoSaveItem({
    super.key,
    required this.tapAction,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Gaps.v40,
          Text(
            '저장한 지원 사업이 없어요',
            style: AppTextStyles.bd4.copyWith(color: AppColors.g4),
          ),
          Gaps.v8,
          GestureDetector(
            onTap: tapAction,
            child: Container(
              width: 130,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(
                  width: 1,
                  color: AppColors.g3,
                ),
              ),
              child: Center(
                child: Text(
                  '지원사업 저장하러가기',
                  style: AppTextStyles.bd6.copyWith(color: AppColors.g4),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
