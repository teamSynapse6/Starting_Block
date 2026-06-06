class LlmModelInfo {
  final String modelName;
  final int size;
  final int chunkCount;

  const LlmModelInfo({
    required this.modelName,
    required this.size,
    required this.chunkCount,
  });

  factory LlmModelInfo.fromJson(Map<String, dynamic> json) {
    return LlmModelInfo(
      modelName: json['model_name']?.toString() ?? '',
      size: int.tryParse(json['size']?.toString() ?? '') ?? 0,
      chunkCount: int.tryParse(json['chunk_count']?.toString() ?? '') ?? 0,
    );
  }
}
