import 'package:shared_preferences/shared_preferences.dart';

class DeleteAllChatData {
  static const String _legacyMetaPrefix = 'llm_chat_meta_';
  static const String _legacyChatPrefix = 'chat_';

  static Future<void> deleteAllLlmChatData() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    final filteredKeys = keys.where((key) =>
        key.startsWith(_legacyMetaPrefix) || key.startsWith(_legacyChatPrefix));

    for (final key in filteredKeys) {
      await prefs.remove(key);
    }
  }
}
