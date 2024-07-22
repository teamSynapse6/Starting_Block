import 'package:html/parser.dart';

class OffCampusDetailModel {
  final int id, saved;
  final String organization,
      title,
      content,
      startDate,
      endDate,
      target,
      targetAge,
      supportType,
      link,
      region,
      postTarget,
      classification,
      contact;
  final bool isBookmarked, isContactExist, isFileUploaded;

  static String decodeHtmlEntities(String htmlString) {
    var document = parse(htmlString);
    return document.body!.text;
  }

  OffCampusDetailModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        organization = json['organization'] ?? '',
        title = decodeHtmlEntities(json['title'] ?? ''),
        content = decodeHtmlEntities(json['content'] ?? ''),
        startDate = json['startDate'] ?? '',
        endDate = json['endDate'] ?? '',
        target = json['target'] ?? '',
        targetAge = json['targetAge'] ?? '',
        supportType = json['supportType'] ?? '',
        link = json['link'] ?? '',
        region = json['region'] ?? '',
        postTarget = json['postTarget'] ?? '',
        saved = json['saved'] as int,
        classification = json['classification'] ?? '',
        contact = json['contact'] ?? '',
        isBookmarked = json['isBookmarked'] ?? false,
        isContactExist = json['isContactExist'] ?? false,
        isFileUploaded = json['isFileUploaded'] ?? false;
}
