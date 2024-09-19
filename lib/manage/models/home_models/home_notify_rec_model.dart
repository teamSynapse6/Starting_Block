import 'package:html/parser.dart';

class HomeAnnouncementRecModel {
  final String announcementType;
  final String keyword;
  final String title;
  final String dday;
  final String detailUrl;
  final int announcementId;

  static String decodeHtmlEntities(String htmlString) {
    var document = parse(htmlString);
    return document.body!.text;
  }

  HomeAnnouncementRecModel.fromJson(Map<String, dynamic> json)
      : announcementType = json['announcementType'] ?? '',
        keyword = json['keyword'] ?? '',
        title = decodeHtmlEntities(json['title'] ?? ''),
        dday = json['dday'] ?? '',
        detailUrl = json['detailUrl'] ?? '',
        announcementId = json['announcementId'] ?? 0;
}
