// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AppAnimation {
  static Widget get chatting_progress_indicator =>
      Lottie.asset('assets/animation/chatting_processing.json', repeat: true);
}
