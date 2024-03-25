class RoadMapAnnounceModel {
  final int roadmapId;
  final String title;
  final bool isAnnouncementSaved;

  RoadMapAnnounceModel.fromJson(Map<String, dynamic> json)
      : roadmapId = json['roadmapId'] as int,
        title = json['title'] ?? '',
        isAnnouncementSaved = json['isAnnouncementSaved'] as bool;
}
