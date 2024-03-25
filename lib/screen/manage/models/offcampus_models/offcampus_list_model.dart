import 'package:html/parser.dart' show parse;

class OffCampusListModel {
  final int announcementId;
  final String departmentName;
  final String title;
  final String startDate;
  final String endDate;
  final bool isBookmarked;

  static String decodeHtmlEntities(String htmlString) {
    var document = parse(htmlString);
    return document.body!.text;
  }

  OffCampusListModel.fromJson(Map<String, dynamic> json)
      : announcementId = json['announcementId'] as int,
        departmentName = json['departmentName'] ?? '',
        title = decodeHtmlEntities(json['title'] ?? ''),
        startDate = json['startDate'] ?? '',
        endDate = json['endDate'] ?? '',
        isBookmarked = json['isBookmarked'] as bool;
}
