import 'package:flutter/material.dart';
import 'package:starting_block/constants/color_table.dart';
import 'package:starting_block/constants/sizes.dart';

class ThemeManage {
  static ThemeData get theme {
    return ThemeData(
      scaffoldBackgroundColor: AppColors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
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
    );
  }
}
