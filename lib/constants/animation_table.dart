// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AppAnimation {
  static Widget get chatting_progress_indicator =>
      Lottie.asset('assets/animation/chatting_processing.json', repeat: true);
  static Widget get leap_after_first => Lottie.asset(
        'assets/animation/leap_after_first.json',
        repeat: true,
        frameRate: FrameRate.max,
        fit: BoxFit.fill,
      );
}
