class RoadMapModel {
  final int roadmapId;
  final String title;
  final String roadmapStatus;
  final int sequence;

  RoadMapModel.fromJson(Map<String, dynamic> json)
      : roadmapId = json['roadmapId'] as int,
        title = json['title'] ?? '',
        roadmapStatus = json['roadmapStatus'] ?? '',
        sequence = json['sequence'] as int;
}
