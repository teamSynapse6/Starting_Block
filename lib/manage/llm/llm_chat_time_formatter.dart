import 'package:intl/intl.dart';

class LlmChatTimeFormatter {
  const LlmChatTimeFormatter._();

  static String formatMessageTime(int messageTime) {
    if (messageTime <= 0) {
      return '';
    }
    final dateTime = parseMessageDateTime(messageTime);
    var formattedTime = DateFormat('a h:mm', 'ko_KR').format(dateTime);
    formattedTime = formattedTime.replaceAll('AM', '오전').replaceAll('PM', '오후');
    return formattedTime;
  }

  static DateTime parseMessageDateTime(int messageTime) {
    final dateTimeString = messageTime.toString().padLeft(12, '0');
    final formattedString =
        '${dateTimeString.substring(0, 4)}-${dateTimeString.substring(4, 6)}-${dateTimeString.substring(6, 8)} ${dateTimeString.substring(8, 10)}:${dateTimeString.substring(10, 12)}';
    return DateTime.tryParse(formattedString) ?? DateTime.now();
  }

  static int formatCurrentTime(DateTime currentTime) {
    return int.parse(
      '${currentTime.year}${currentTime.month.toString().padLeft(2, '0')}${currentTime.day.toString().padLeft(2, '0')}${currentTime.hour.toString().padLeft(2, '0')}${currentTime.minute.toString().padLeft(2, '0')}',
    );
  }

  static int? timeFromIso(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    final parsed = DateTime.tryParse(value);
    if (parsed == null) {
      return null;
    }
    return formatCurrentTime(parsed.toLocal());
  }
}
