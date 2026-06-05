import 'package:flutter/material.dart';
import 'package:starting_block/constants/font_table.dart';

class LlmTextParser {
  const LlmTextParser._();

  static TextSpan parse(
    String text, {
    required Color color,
    TextStyle? baseStyle,
  }) {
    final effectiveBaseStyle =
        (baseStyle ?? AppTextStyles.bd4).copyWith(color: color);

    return TextSpan(
      style: effectiveBaseStyle,
      children: _parseInline(text, effectiveBaseStyle, color),
    );
  }

  static List<InlineSpan> _parseInline(
    String text,
    TextStyle baseStyle,
    Color color,
  ) {
    final spans = <InlineSpan>[];
    final buffer = StringBuffer();
    var index = 0;

    void flushBuffer() {
      if (buffer.isEmpty) return;
      spans.add(TextSpan(text: buffer.toString(), style: baseStyle));
      buffer.clear();
    }

    while (index < text.length) {
      final marker = _matchMarker(text, index);

      if (marker == null) {
        buffer.write(text[index]);
        index += 1;
        continue;
      }

      final closeIndex = text.indexOf(marker.token, index + marker.length);
      if (closeIndex <= index + marker.length) {
        buffer.write(marker.token);
        index += marker.length;
        continue;
      }

      final contentStart = index + marker.length;
      final content = text.substring(contentStart, closeIndex);
      if (content.trim().isEmpty) {
        buffer.write(marker.token);
        index += marker.length;
        continue;
      }

      flushBuffer();
      spans.add(TextSpan(
        text: content,
        style: _styleForMarker(baseStyle, color, marker),
      ));
      index = closeIndex + marker.length;
    }

    flushBuffer();
    return spans;
  }

  static _LlmMarkdownMarker? _matchMarker(String text, int index) {
    if (text.startsWith('**', index)) {
      return const _LlmMarkdownMarker('**', _LlmMarkdownMarkerType.bold);
    }
    if (text.startsWith('__', index)) {
      return const _LlmMarkdownMarker('__', _LlmMarkdownMarkerType.bold);
    }
    if (text.startsWith('`', index)) {
      return const _LlmMarkdownMarker('`', _LlmMarkdownMarkerType.code);
    }
    if (text.startsWith('*', index)) {
      return const _LlmMarkdownMarker('*', _LlmMarkdownMarkerType.italic);
    }
    if (text.startsWith('_', index)) {
      return const _LlmMarkdownMarker('_', _LlmMarkdownMarkerType.italic);
    }
    return null;
  }

  static TextStyle _styleForMarker(
    TextStyle baseStyle,
    Color color,
    _LlmMarkdownMarker marker,
  ) {
    switch (marker.type) {
      case _LlmMarkdownMarkerType.bold:
        return AppTextStyles.bd3.copyWith(color: color);
      case _LlmMarkdownMarkerType.italic:
        return baseStyle.copyWith(fontStyle: FontStyle.italic);
      case _LlmMarkdownMarkerType.code:
        return AppTextStyles.bd4.copyWith(
          color: color,
          fontFamily: 'monospace',
          backgroundColor: color.withValues(alpha: 0.08),
        );
    }
  }
}

enum _LlmMarkdownMarkerType {
  bold,
  italic,
  code,
}

class _LlmMarkdownMarker {
  final String token;
  final _LlmMarkdownMarkerType type;

  const _LlmMarkdownMarker(this.token, this.type);

  int get length => token.length;
}
