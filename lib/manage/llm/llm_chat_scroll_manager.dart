import 'package:flutter/widgets.dart';

class LlmChatScrollManager {
  int _requestId = 0;

  void scrollToBottom(
    ScrollController controller, {
    Duration duration = const Duration(milliseconds: 180),
  }) {
    final requestId = ++_requestId;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (requestId != _requestId || !controller.hasClients) {
          return;
        }

        final position = controller.position;
        final target = position.maxScrollExtent.clamp(
          position.minScrollExtent,
          position.maxScrollExtent,
        );

        if (position.pixels > target) {
          controller.jumpTo(target);
          return;
        }

        final distance = (target - position.pixels).abs();
        if (distance < 1) {
          return;
        }

        controller.animateTo(
          target,
          duration: duration,
          curve: Curves.easeOutCubic,
        );
      });
    });
  }
}
