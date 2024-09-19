import 'package:flutter/material.dart';
import 'package:starting_block/constants/constants.dart';

class OnCampusSupprtGroupDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  OnCampusSupprtGroupDelegate(this.tabBar);

  @override
  double get minExtent => 48;
  @override
  double get maxExtent => 48;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppColors.white, // 탭바 배경색 설정
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(OnCampusSupprtGroupDelegate oldDelegate) {
    return false;
  }
}
