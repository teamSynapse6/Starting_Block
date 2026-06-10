import 'package:starting_block/manage/model_manage.dart';

class LlmPromptBuilder {
  static const int _recentMessageLimit = 6;

  static const String systemInstruction = '''
당신은 스타팅블록 앱의 공고 분석 AI입니다.
사용자가 보고 있는 창업 지원사업 공고의 첨부파일과 공고 정보를 바탕으로 정확하고 간결하게 답변합니다.
''';

  static String buildPrompt({
    required String context,
    required String userMessage,
    required List<Message> recentMessages,
  }) {
    final conversation = _recentConversationText(
      recentMessages,
      userMessage: userMessage,
    );

    return '''
아래 공고 컨텍스트와 최근 대화를 참고해 사용자의 질문에 답변해 주세요.

규칙:
- 컨텍스트에 근거가 있는 내용은 구체적으로 답변합니다.
- 컨텍스트만으로 확실하지 않은 내용은 모른다고 말하고, 확인이 필요한 항목을 안내합니다.
- 지원사업 공고와 무관한 내용을 추측해서 만들지 않습니다.
- 답변은 자연스러운 한국어로 작성합니다.

[공고 컨텍스트]
${context.trim().isEmpty ? '제공된 컨텍스트가 없습니다.' : context.trim()}

[최근 대화]
${conversation.isEmpty ? '최근 대화가 없습니다.' : conversation}

[사용자 질문]
$userMessage
''';
  }

  static String _recentConversationText(
    List<Message> messages, {
    required String userMessage,
  }) {
    final filtered =
        messages.where((message) => message.message.trim().isNotEmpty).toList();
    if (filtered.isNotEmpty &&
        filtered.last.isUser &&
        filtered.last.message.trim() == userMessage.trim()) {
      filtered.removeLast();
    }
    final start = filtered.length > _recentMessageLimit
        ? filtered.length - _recentMessageLimit
        : 0;
    return filtered
        .sublist(start)
        .map((message) =>
            '${message.isUser ? '사용자' : 'AI'}: ${message.message.trim()}')
        .join('\n');
  }
}
