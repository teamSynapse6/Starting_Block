import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color bluebg = Color(0XFFF0F3FF); //0108변경_기존:F1FCFF
  static const Color bluelight = Color(0XFFB1C5F6); //0108변경_기존:9DECFF
  static const Color blue = Color(0XFF5E8BFF); //0108변경_기존:2965FF
  static const Color bluedark = Color(0XFF213049); //0108변경_기존:111C2F
  static const Color bluedeep = Color(0XFF3255A4); //0108신규추가
  static const Color purple = Color(0XFFC03AFF);

  // Secondary Colors
  static const Color white = Color(0XFFffffff);
  static const Color salmon = Color(0XFFFF6B00); //0108신규추가_세컨더리

  // Gray Scale Colors
  static const Color g1 = Color(0XFFf4f4f4);
  static const Color g2 = Color(0XFFE0E0E0);
  static const Color g3 = Color(0XFFDEDEde);
  static const Color g4 = Color(0XFF8f8f8f);
  static const Color g5 = Color(0xFF686868);
  static const Color g6 = Color(0XFF474747);
  static const Color black = Color(0XFF121212);

  // Active Color Colors
  static const Color activered = Color(0XFFe63312);

  // chipsColor
  static const Color chipsColor = Color(0XFFC8C8C8);

  // BG Color
  static const Color secondaryBG = Color(0XFFF3F4F6); //secondary BG 컬러

  /*교내지원사업 카드 컬러*/
  //창업지원공고 카드_컨테이너 영역
  static const Color oncampusLargePressed =
      Color(0XFF4D7AF1); // 창업지원공고 카드 Pressed
  //창업지원공고 카드 내 원형 영역
  static const Color oncampusDeepBlue = Color(0XFF4E7FFF); // 교내지원사업 딥불루 컬러 카드

  //창업지원단 카드
  static const Color oncampusMedium = Color(0XFFFDA68A); // 창업지원단 카드 기본
  static const Color oncampusMediumPressed =
      Color(0XFFFF994F); // 창업지원단 카드 Pressed

  //창업제도 카드
  static const Color oncampusSmallSys = Color(0XFFDBB7FF); // 창업제도 카드 기본
  static const Color oncampusSmallSysPressed =
      Color(0XFFCB98FF); // 창업제도 카드 Pressed

  //창업강의 카드
  static const Color oncampusSmallClassPressed =
      Color(0XFF95B4FF); // 창업제도 카드 Pressed
}
