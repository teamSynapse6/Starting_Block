class LlmModelInfo {
  final String modelName;
  final String format;
  final int size;
  final int chunkCount;

  const LlmModelInfo({
    required this.modelName,
    required this.format,
    required this.size,
    required this.chunkCount,
  });

  String get normalizedFormat {
    final cleanedFormat = format.trim().replaceFirst(RegExp(r'^\.'), '');
    if (cleanedFormat.isNotEmpty) {
      return cleanedFormat;
    }

    final sanitizedModelName = Uri.parse('/$modelName').pathSegments.last;
    final extensionIndex = sanitizedModelName.lastIndexOf('.');
    if (extensionIndex <= 0 ||
        extensionIndex == sanitizedModelName.length - 1) {
      return '';
    }
    return sanitizedModelName.substring(extensionIndex + 1);
  }

  String get localModelName {
    final sanitizedModelName = Uri.parse('/$modelName').pathSegments.last;
    final extension = normalizedFormat;
    if (extension.isEmpty ||
        sanitizedModelName
            .toLowerCase()
            .endsWith('.${extension.toLowerCase()}')) {
      return sanitizedModelName;
    }
    return '$sanitizedModelName.$extension';
  }

  factory LlmModelInfo.fromJson(Map<String, dynamic> json) {
    return LlmModelInfo(
      modelName: json['model_name']?.toString() ?? '',
      format: json['format']?.toString() ?? '',
      size: int.tryParse(json['size']?.toString() ?? '') ?? 0,
      chunkCount: int.tryParse(json['chunk_count']?.toString() ?? '') ?? 0,
    );
  }
}
