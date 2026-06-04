import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class LlmChatMeta {
  final int announcementId;
  final String title;
  final String threadId;
  final String lastPreview;
  final int lastUpdatedAt;
  final bool hasRunningGeneration;

  const LlmChatMeta({
    required this.announcementId,
    required this.title,
    required this.threadId,
    required this.lastPreview,
    required this.lastUpdatedAt,
    required this.hasRunningGeneration,
  });

  Map<String, dynamic> toJson() {
    return {
      'announcementId': announcementId,
      'title': title,
      'threadId': threadId,
      'lastPreview': lastPreview,
      'lastUpdatedAt': lastUpdatedAt,
      'hasRunningGeneration': hasRunningGeneration,
    };
  }

  factory LlmChatMeta.fromJson(Map<String, dynamic> json) {
    return LlmChatMeta(
      announcementId: _toInt(json['announcementId']),
      title: json['title']?.toString() ?? '',
      threadId: json['threadId']?.toString() ?? '',
      lastPreview: json['lastPreview']?.toString() ?? '',
      lastUpdatedAt: _toInt(json['lastUpdatedAt']),
      hasRunningGeneration: json['hasRunningGeneration'] == true,
    );
  }

  LlmChatMeta copyWith({
    String? title,
    String? threadId,
    String? lastPreview,
    int? lastUpdatedAt,
    bool? hasRunningGeneration,
  }) {
    return LlmChatMeta(
      announcementId: announcementId,
      title: title ?? this.title,
      threadId: threadId ?? this.threadId,
      lastPreview: lastPreview ?? this.lastPreview,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      hasRunningGeneration: hasRunningGeneration ?? this.hasRunningGeneration,
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}

class LlmListManage {
  static const String _metaPrefix = 'llm_chat_meta_';
  static const String _legacyPrefix = 'chat_';

  static String _metaKey(int announcementId) => '$_metaPrefix$announcementId';

  static Future<LlmChatMeta?> loadChatMeta(int announcementId) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedData = prefs.getString(_metaKey(announcementId));
    if (encodedData == null || encodedData.isEmpty) {
      return null;
    }

    try {
      final jsonData = jsonDecode(encodedData);
      if (jsonData is Map<String, dynamic>) {
        return LlmChatMeta.fromJson(jsonData);
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  static Future<void> saveChatMeta(LlmChatMeta meta) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_metaKey(meta.announcementId), jsonEncode(meta));
  }

  static Future<void> upsertChatMeta({
    required int announcementId,
    required String title,
    required String threadId,
    String? lastPreview,
    int? lastUpdatedAt,
    bool? hasRunningGeneration,
  }) async {
    final current = await loadChatMeta(announcementId);
    final meta = current == null
        ? LlmChatMeta(
            announcementId: announcementId,
            title: title,
            threadId: threadId,
            lastPreview: lastPreview ?? '',
            lastUpdatedAt: lastUpdatedAt ?? _formatCurrentTime(DateTime.now()),
            hasRunningGeneration: hasRunningGeneration ?? false,
          )
        : current.copyWith(
            title: title,
            threadId: threadId,
            lastPreview: lastPreview,
            lastUpdatedAt: lastUpdatedAt,
            hasRunningGeneration: hasRunningGeneration,
          );
    await saveChatMeta(meta);
  }

  // 마이페이지 LLM 목록에서 사용하는 메소드입니다.
  static Future<List<LlmListModel>> loadChatData() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((key) => key.startsWith(_metaPrefix));

    final tempList = <LlmListModel>[];
    for (final key in keys) {
      final value = prefs.getString(key);
      if (value == null) {
        continue;
      }
      try {
        final jsonData = jsonDecode(value);
        if (jsonData is Map<String, dynamic>) {
          tempList.add(LlmListModel.fromMeta(LlmChatMeta.fromJson(jsonData)));
        }
      } catch (_) {
        continue;
      }
    }

    tempList.sort((a, b) => b.lastDate.compareTo(a.lastDate));
    return tempList;
  }

  static int _formatCurrentTime(DateTime currentTime) {
    return int.parse(
        '${currentTime.year}${currentTime.month.toString().padLeft(2, '0')}${currentTime.day.toString().padLeft(2, '0')}${currentTime.hour.toString().padLeft(2, '0')}${currentTime.minute.toString().padLeft(2, '0')}');
  }
}

class LlmListModel {
  final int id;
  final String title;
  final String lastMessage;
  final int lastDate;

  LlmListModel.fromMeta(LlmChatMeta meta)
      : id = meta.announcementId,
        title = meta.title,
        lastMessage = meta.lastPreview,
        lastDate = meta.lastUpdatedAt;
}

class DeleteAllChatData {
  static Future<void> deleteAllLlmChatData() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    final filteredKeys = keys.where((key) =>
        key.startsWith(LlmListManage._metaPrefix) ||
        key.startsWith(LlmListManage._legacyPrefix));

    for (final key in filteredKeys) {
      await prefs.remove(key);
    }
  }
}
