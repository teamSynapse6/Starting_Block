import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class DaskStroke extends StatelessWidget {
  final double height;
  final Color color;

  const DaskStroke({
    super.key,
    this.height = 2, // 선 두께를 2로 변경
    this.color = AppColors.blue, // 선 색상을 AppColors.blue로 설정
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 4.0;
        const dashSpace = 4.0; // dash 간격을 4로 설정
        final dashHeight = height;
        // 총 dash 개수를 계산할 때 dash 간격을 고려하여 수정
        final dashCount =
            ((boxWidth + dashSpace) / (dashWidth + dashSpace)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            // 각 대시와 공백을 생성
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}

class LineStroke extends StatelessWidget {
  final double height;
  final Color color;

  const LineStroke({
    super.key,
    this.height = 2, // 선 두께
    this.color = AppColors.blue, // 선 색상
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height, // 선의 높이 (두께) 설정
      color: color, // 선의 색상 설정
    );
  }
}
