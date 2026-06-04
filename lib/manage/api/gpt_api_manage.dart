import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:starting_block/manage/api/api_baseurl.dart';
import 'package:starting_block/manage/api/userinfo_api_manage.dart';
import 'package:starting_block/manage/model_manage.dart';

class GptApi {
  static Future<Map<String, String>> getHeaders() async {
    String? accessToken = await UserTokenManage.getAccessToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken'
    };
  }

  static String baseUrl = apiBaseUrl;
  static String gptStart = 'llm/start';
  static String gptChat = 'llm/chat';
  static String gptEnd = 'llm/delete';

  //대화를 위한 쓰레드 생성 메소드
  static Future<String> getGptStart({int retryCount = 1}) async {
    final gptStartUrl = Uri.parse('$baseUrl/$gptStart');
    final headers = await getHeaders();
    final response = await http.post(gptStartUrl, headers: headers);
    if (response.statusCode == 200) {
      final threadId = jsonDecode(response.body)['thread_id'];
      debugPrint('쓰레드 ID: $threadId');
      return threadId;
    } else if (response.statusCode == 401 && retryCount > 0) {
      await UserInfoManageApi.updateAccessToken();
      return getGptStart(retryCount: retryCount - 1);
    } else {
      throw Exception('서버 오류: ${response.statusCode}');
    }
  }

  //채팅 메소드 (SSE 스트리밍)
  static Stream<String> postGptChat(
      String threadId, String message, int announcementId,
      {int retryCount = 1}) async* {
    final gptChatUrl = Uri.parse('$baseUrl/$gptChat');
    final headers = await getHeaders();

    final client = http.Client();
    try {
      final request = http.Request('POST', gptChatUrl);
      request.headers.addAll(headers);
      request.body = jsonEncode({
        'thread_id': threadId,
        'message': message,
        'announcement_id': announcementId,
      });

      final streamedResponse = await client.send(request);

      if (streamedResponse.statusCode == 200) {
        String buffer = '';
        await for (final chunk
            in streamedResponse.stream.transform(utf8.decoder)) {
          buffer += chunk;
          final lines = buffer.split('\n');
          buffer = lines.removeLast(); // 마지막 불완전한 줄은 버퍼에 유지
          for (final line in lines) {
            final trimmed = line.trim();
            if (trimmed.startsWith('data: ')) {
              final data = trimmed.substring(6);
              if (data.isNotEmpty && data != '[DONE]') {
                yield data;
              }
            }
          }
        }
        // 버퍼에 남은 마지막 데이터 처리
        final trimmed = buffer.trim();
        if (trimmed.startsWith('data: ')) {
          final data = trimmed.substring(6);
          if (data.isNotEmpty && data != '[DONE]') {
            yield data;
          }
        }
      } else if (streamedResponse.statusCode == 401 && retryCount > 0) {
        await UserInfoManageApi.updateAccessToken();
        yield* postGptChat(threadId, message, announcementId,
            retryCount: retryCount - 1);
      } else {
        throw Exception('서버 오류: ${streamedResponse.statusCode}');
      }
    } finally {
      client.close();
    }
  }

  //대화 종료를 위한 쓰레드 삭제 메소드
  static Future<bool> deleteGptEnd(String threadId,
      {int retryCount = 1}) async {
    final gptEndUrl = Uri.parse('$baseUrl/$gptEnd?thread_id=$threadId');
    final headers = await getHeaders();
    final response = await http.delete(gptEndUrl, headers: headers);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      return responseData['deleted'] ?? false;
    } else if (response.statusCode == 401 && retryCount > 0) {
      await UserInfoManageApi.updateAccessToken();
      return deleteGptEnd(threadId, retryCount: retryCount - 1);
    } else {
      throw Exception('서버 오류: ${response.statusCode}');
    }
  }
}
