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
  String get rawData => _stringFromDynamic(data['raw_data']);
  String get context => data['context']?.toString() ?? '';
  String get detail => data['detail']?.toString() ?? '';
  String get value => _stringFromDynamic(data['value']);
  String get retrievalData => _stringFromDynamic(
        data['retrieval_data'] ?? data['retrevial_data'],
      );

  String get retrievalText {
    final candidates = [text, response, context, rawData, retrievalData, value];
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

  static String _stringFromDynamic(dynamic value) {
    if (value == null) {
      return '';
    }
    if (value is List) {
      return value
          .map((item) => item?.toString() ?? '')
          .where((item) => item.trim().isNotEmpty)
          .join('\n');
    }
    return value.toString();
  }
}
