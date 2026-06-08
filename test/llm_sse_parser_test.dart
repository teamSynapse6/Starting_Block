import 'package:flutter_test/flutter_test.dart';
import 'package:starting_block/manage/api/llm_api_manage.dart';

void main() {
  group('LlmSseParser', () {
    test('parses status, thinking, token, and done events', () {
      final parser = LlmSseParser();

      final events = parser.addChunk(
        'event: status\n'
        'data: {"stage":"request_received"}\n\n'
        'event: thinking\n'
        'data: {"text":"생각"}\n\n'
        'event: token\n'
        'data: {"text":"답"}\n\n'
        'event: done\n'
        'data: {"response":"답변"}\n\n',
      );

      expect(events, hasLength(4));
      expect(events[0].isStatus, isTrue);
      expect(events[0].stage, 'request_received');
      expect(events[1].isThinking, isTrue);
      expect(events[1].text, '생각');
      expect(events[2].isToken, isTrue);
      expect(events[2].text, '답');
      expect(events[3].isDone, isTrue);
      expect(events[3].response, '답변');
    });

    test('keeps an incomplete frame buffered across chunks', () {
      final parser = LlmSseParser();

      expect(parser.addChunk('event: token\ndata: {"te'), isEmpty);
      final events = parser.addChunk('xt":"hello"}\n\n');

      expect(events, hasLength(1));
      expect(events.single.event, 'token');
      expect(events.single.text, 'hello');
    });

    test('joins multiple data lines in one event', () {
      final parser = LlmSseParser();

      final events = parser.addChunk(
        'event: token\n'
        'data: hello\n'
        'data: world\n\n',
      );

      expect(events, hasLength(1));
      expect(events.single.event, 'token');
      expect(events.single.text, 'hello\nworld');
    });

    test('reads retrieval data arrays from done events', () {
      final parser = LlmSseParser();

      final events = parser.addChunk(
        'event: done\n'
        'data: {"retrevial_data":["첫 번째 공고 내용","두 번째 공고 내용"]}\n\n',
      );

      expect(events, hasLength(1));
      expect(events.single.isDone, isTrue);
      expect(events.single.retrievalText, '첫 번째 공고 내용\n두 번째 공고 내용');
    });
  });
}
