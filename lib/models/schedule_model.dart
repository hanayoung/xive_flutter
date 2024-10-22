class ScheduleModel {
  final String eventDay, eventImageUrl;
  final List<int> ticketId;

  ScheduleModel.fromJson(Map<String, dynamic> json)
      : eventDay = json['eventDay'],
        ticketId = List<int>.from(json['ticketId']),
        eventImageUrl = json['eventImageUrl'];

  @override
  String toString() {
    return 'ScheduleModel(eventDay: $eventDay, eventImageUrl: $eventImageUrl, ticketId: $ticketId)';
  }
}
