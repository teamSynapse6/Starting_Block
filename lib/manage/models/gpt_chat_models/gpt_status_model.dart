class GptStatusModel {
  final PageModel page;
  final List<IncidentModel> incidents;

  GptStatusModel.fromJson(Map<String, dynamic> json)
      : page = PageModel.fromJson(json['page']),
        incidents = json['incidents'] != null
            ? (json['incidents'] as List)
                .map((e) => IncidentModel.fromJson(e))
                .toList()
            : [];
}

class PageModel {
  final String id;
  final String name;
  final String url;
  final String updatedAt;

  PageModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? '',
        name = json['name'] ?? '',
        url = json['url'] ?? '',
        updatedAt = json['updated_at'] ?? '';
}

class IncidentModel {
  final String createdAt;
  final String id;
  final String impact;
  final List<IncidentUpdateModel> incidentUpdates;
  final String monitoringAt;
  final String name;
  final String pageId;
  final String resolvedAt;
  final String shortlink;
  final String status;
  final String updatedAt;

  IncidentModel.fromJson(Map<String, dynamic> json)
      : createdAt = json['created_at'] ?? '',
        id = json['id'] ?? '',
        impact = json['impact'] ?? '',
        incidentUpdates = json['incident_updates'] != null
            ? (json['incident_updates'] as List)
                .map((e) => IncidentUpdateModel.fromJson(e))
                .toList()
            : [],
        monitoringAt = json['monitoring_at'] ?? '',
        name = json['name'] ?? '',
        pageId = json['page_id'] ?? '',
        resolvedAt = json['resolved_at'] ?? '',
        shortlink = json['shortlink'] ?? '',
        status = json['status'] ?? '',
        updatedAt = json['updated_at'] ?? '';
}

class IncidentUpdateModel {
  final String body;
  final String createdAt;
  final String displayAt;
  final String id;
  final String incidentId;
  final String status;
  final String updatedAt;

  IncidentUpdateModel.fromJson(Map<String, dynamic> json)
      : body = json['body'] ?? '',
        createdAt = json['created_at'] ?? '',
        displayAt = json['display_at'] ?? '',
        id = json['id'] ?? '',
        incidentId = json['incident_id'] ?? '',
        status = json['status'] ?? '',
        updatedAt = json['updated_at'] ?? '';
}
