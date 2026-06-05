import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:starting_block/manage/llm/llm_text_parser.dart';

void main() {
  group('LlmTextParser', () {
    test('parses bold markers without rendering markdown symbols', () {
      final span = LlmTextParser.parse(
        '**주요 내용 요약:** 지원 대상입니다.',
        color: Colors.black,
      );

      expect(span.toPlainText(), '주요 내용 요약: 지원 대상입니다.');
      expect(span.children, hasLength(2));

      final boldSpan = span.children!.first as TextSpan;
      expect(boldSpan.text, '주요 내용 요약:');
      expect(boldSpan.style!.fontWeight, FontWeight.w700);
    });

    test('keeps unmatched markers as plain text', () {
      final span = LlmTextParser.parse(
        '**지원 대상입니다.',
        color: Colors.black,
      );

      expect(span.toPlainText(), '**지원 대상입니다.');
    });

    test('parses inline italic and code markers', () {
      final span = LlmTextParser.parse(
        '*중요* `IP` 항목',
        color: Colors.black,
      );

      expect(span.toPlainText(), '중요 IP 항목');
      expect(span.children, hasLength(4));

      final italicSpan = span.children!.first as TextSpan;
      expect(italicSpan.style!.fontStyle, FontStyle.italic);

      final codeSpan = span.children![2] as TextSpan;
      expect(codeSpan.text, 'IP');
      expect(codeSpan.style!.fontFamily, 'monospace');
    });
  });
}
