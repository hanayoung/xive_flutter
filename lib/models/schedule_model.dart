class ScheduleModel {
  final String eventDay, eventImageUrl;
  final List<int> ticketId;

  ScheduleModel.fromJson(Map<String, dynamic> json)
      : eventDay = json['eventDay'],
        ticketId = json['ticketId'],
        eventImageUrl = json['eventImageUrl'];
}
