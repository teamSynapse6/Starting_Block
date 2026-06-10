import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_foundation_models/flutter_foundation_models.dart';
import 'package:starting_block/manage/llm/llm_prompt_builder.dart';
import 'package:starting_block/manage/model_manage.dart';

class AppleIntelligenceAvailability {
  final bool isAvailable;
  final String unavailableReason;

  const AppleIntelligenceAvailability({
    required this.isAvailable,
    this.unavailableReason = '',
  });
}

class AppleIntelligenceLlmManage {
  static const String modelValue = 'apple_intelligence';
  static const String displayName = 'Apple Intelligence';
  static const MethodChannel _settingsChannel =
      MethodChannel('starting_block/apple_intelligence_settings');

  static bool get isSupportedPlatform => Platform.isIOS;

  static Future<AppleIntelligenceAvailability> checkAvailability() async {
    if (!isSupportedPlatform) {
      return const AppleIntelligenceAvailability(
        isAvailable: false,
        unavailableReason: 'iOS에서만 사용할 수 있습니다.',
      );
    }

    try {
      final availability = await SystemLanguageModel.availability;
      return AppleIntelligenceAvailability(
        isAvailable: availability.isAvailable,
        unavailableReason: availability.unavailableReason ?? '',
      );
    } catch (error) {
      return AppleIntelligenceAvailability(
        isAvailable: false,
        unavailableReason: error.toString(),
      );
    }
  }

  static Future<void> openSettings() async {
    if (!isSupportedPlatform) {
      return;
    }
    try {
      await _settingsChannel.invokeMethod<void>('open');
    } catch (_) {}
  }

  static Stream<String> generateReply({
    required String userMessage,
    required String context,
    required List<Message> recentMessages,
  }) async* {
    final availability = await checkAvailability();
    if (!availability.isAvailable) {
      final reason = availability.unavailableReason.trim();
      throw StateError(
        reason.isEmpty ? 'Apple Intelligence를 사용할 수 없습니다.' : reason,
      );
    }

    final session = await LanguageModelSession.create(
      instructions: LlmPromptBuilder.systemInstruction,
    );
    final prompt = LlmPromptBuilder.buildPrompt(
      context: context,
      userMessage: userMessage,
      recentMessages: recentMessages,
    );

    try {
      final buffer = StringBuffer();
      await for (final text in session.streamResponseTo(prompt)) {
        final current = buffer.toString();
        final delta =
            text.startsWith(current) ? text.substring(current.length) : text;
        if (delta.isEmpty) {
          continue;
        }
        buffer.write(delta);
        yield delta;
      }
    } finally {
      await session.dispose();
    }
  }
}
