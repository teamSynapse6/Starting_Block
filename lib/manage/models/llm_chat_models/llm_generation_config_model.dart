class LlmGenerationConfig {
  static const double defaultTemperature = 0.7;
  static const double defaultTopP = 0.9;
  static const int defaultTopK = 40;
  static const int defaultMaxOutputTokens = 4096;
  static const String defaultSystemInstruction = '';

  final String modelName;
  final DateTime configDate;
  final double temperature;
  final double topP;
  final int topK;
  final int maxOutputTokens;
  final String systemInstruction;

  const LlmGenerationConfig({
    required this.modelName,
    required this.configDate,
    required this.temperature,
    required this.topP,
    required this.topK,
    required this.maxOutputTokens,
    required this.systemInstruction,
  });

  factory LlmGenerationConfig.defaults({
    required String modelName,
    String systemInstruction = defaultSystemInstruction,
  }) {
    return LlmGenerationConfig(
      modelName: modelName,
      configDate: DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      temperature: defaultTemperature,
      topP: defaultTopP,
      topK: defaultTopK,
      maxOutputTokens: defaultMaxOutputTokens,
      systemInstruction: systemInstruction,
    );
  }

  factory LlmGenerationConfig.fromJson(Map<String, dynamic> json) {
    return LlmGenerationConfig(
      modelName: json['model_name']?.toString() ?? '',
      configDate: _dateFromJson(json['config_date']),
      temperature: double.tryParse(json['temperature']?.toString() ?? '') ??
          defaultTemperature,
      topP: double.tryParse(json['top_p']?.toString() ?? '') ?? defaultTopP,
      topK: int.tryParse(json['top_k']?.toString() ?? '') ?? defaultTopK,
      maxOutputTokens:
          int.tryParse(json['max_output_tokens']?.toString() ?? '') ??
              defaultMaxOutputTokens,
      systemInstruction: json['systemInstruction']?.toString() ??
          json['system_instruction']?.toString() ??
          defaultSystemInstruction,
    );
  }

  LlmGenerationConfig copyWith({
    String? modelName,
    DateTime? configDate,
    double? temperature,
    double? topP,
    int? topK,
    int? maxOutputTokens,
    String? systemInstruction,
  }) {
    return LlmGenerationConfig(
      modelName: modelName ?? this.modelName,
      configDate: configDate ?? this.configDate,
      temperature: temperature ?? this.temperature,
      topP: topP ?? this.topP,
      topK: topK ?? this.topK,
      maxOutputTokens: maxOutputTokens ?? this.maxOutputTokens,
      systemInstruction: systemInstruction ?? this.systemInstruction,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'model_name': modelName,
      'config_date': configDate.toIso8601String(),
      'temperature': temperature,
      'top_p': topP,
      'top_k': topK,
      'max_output_tokens': maxOutputTokens,
      'systemInstruction': systemInstruction,
    };
  }

  static DateTime _dateFromJson(dynamic value) {
    if (value is DateTime) {
      return value;
    }
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value, isUtc: true);
    }
    final text = value?.toString() ?? '';
    return DateTime.tryParse(text) ??
        DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
  }
}
