class EventModel {
  final String eventWebUrl;
  final int eventId;

  EventModel.fromJson(Map<String, dynamic> json)
      : eventId = json['eventId'],
        eventWebUrl = json['eventWebUrl'];
}
