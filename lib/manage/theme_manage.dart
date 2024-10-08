import 'package:flutter/material.dart';
import 'package:starting_block/constants/color_table.dart';
import 'package:starting_block/constants/font_table.dart';
import 'package:starting_block/constants/sizes.dart';

class ThemeManage {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
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
          height: 72),
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
        thumbColor:
            WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.white;
          }
          return AppColors.white; // 기본 상태의 색상
        }),
        trackColor:
            WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.blue; // 선택된 상태의 트랙 색상
          }
          return AppColors.g1; // 기본 상태의 트랙 색상
        }),
        trackOutlineColor:
            WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.transparent; // 선택된 상태의 트랙 색상
          }
          return Colors.transparent;
        }),
      ),
      tabBarTheme: TabBarTheme(
        splashFactory: NoSplash.splashFactory,
        labelStyle: AppTextStyles.bd1,
        unselectedLabelStyle: AppTextStyles.bd2,
        labelColor: AppColors.blue,
        unselectedLabelColor: AppColors.g4,
        indicatorColor: AppColors.blue,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: AppColors.g2,
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            return Colors.transparent; // overlay 색상을 투명으로 설정
          },
        ),
      ),
      cardTheme: const CardTheme(
        elevation: 0,
      ),
      canvasColor: AppColors.white,
      colorScheme: ColorScheme.fromSwatch().copyWith(primary: AppColors.blue),
      splashColor: AppColors.g2,
      highlightColor: AppColors.g1,
    );
  }
}
