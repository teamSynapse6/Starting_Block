class LlmStreamEvent {
  final String event;
  final Map<String, dynamic> data;

  const LlmStreamEvent({
    required this.event,
    required this.data,
  });

  String get stage => data['stage']?.toString() ?? '';
  String get text => data['text']?.toString() ?? '';
  String get response => data['response']?.toString() ?? '';
  String get rawData => data['raw_data']?.toString() ?? '';
  String get context => data['context']?.toString() ?? '';
  String get detail => data['detail']?.toString() ?? '';
  String get value => data['value']?.toString() ?? '';

  String get retrievalText {
    final candidates = [text, response, context, rawData, value];
    return candidates.firstWhere(
      (candidate) => candidate.trim().isNotEmpty,
      orElse: () => '',
    );
  }

  bool get isToken => event == 'token';
  bool get isThinking => event == 'thinking';
  bool get isStatus => event == 'status';
  bool get isDone => event == 'done';
  bool get isError => event == 'error';
}
