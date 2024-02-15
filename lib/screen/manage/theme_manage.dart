import 'package:flutter/material.dart';
import 'package:starting_block/constants/color_table.dart';
import 'package:starting_block/constants/font_table.dart';
import 'package:starting_block/constants/sizes.dart';

class ThemeManage {
  static ThemeData get theme {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.blue,
          fontSize: Sizes.size8,
          fontWeight: FontWeight.w600,
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.g2),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.g2),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.activered),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.activered),
        ),
      ),
      bottomAppBarTheme: const BottomAppBarTheme(
        padding: EdgeInsets.all(0),
        elevation: 0,
        color: AppColors.white,
        height: 72 + 15, //72는 바텀시트의 높이, 15는 그라데이션 영역
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        elevation: 0,
        backgroundColor: AppColors.white, // 배경색 설정
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24),
          ),
        ),
        clipBehavior: Clip.hardEdge,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.white;
          }
          return AppColors.white; // 기본 상태의 색상
        }),
        trackColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.blue; // 선택된 상태의 트랙 색상
          }
          return AppColors.g1; // 기본 상태의 트랙 색상
        }),
        trackOutlineColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
          if (states.contains(MaterialState.selected)) {
            return Colors.transparent; // 선택된 상태의 트랙 색상
          }
          return Colors.transparent;
        }),
      ),
      tabBarTheme: TabBarTheme(
        labelStyle: AppTextStyles.bd1,
        unselectedLabelStyle: AppTextStyles.bd2,
        labelColor: AppColors.blue,
        unselectedLabelColor: AppColors.g4,
        indicatorColor: AppColors.blue,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        overlayColor: MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.focused) ||
                states.contains(MaterialState.pressed)) {
              return AppColors.g1;
            }
            return AppColors.g1;
          },
        ),
      ),
      cardTheme: const CardTheme(
        elevation: 0,
      ),
      canvasColor: AppColors.white,
    );
  }
}
