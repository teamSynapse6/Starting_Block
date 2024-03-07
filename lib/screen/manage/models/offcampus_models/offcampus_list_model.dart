class OffCampusListModel {
  final int announcementId;
  final String departmentName;
  final String title;
  final String startDate;
  final String endDate;
  final bool isBookmarked;

  OffCampusListModel.fromJson(Map<String, dynamic> json)
      : announcementId = json['announcementId'] as int,
        departmentName = json['departmentName'] ?? '',
        title = json['title'] ?? '',
        startDate = json['startDate'] ?? '',
        endDate = json['endDate'] ?? '',
        isBookmarked = json['isBookmarked'] as bool;
}
