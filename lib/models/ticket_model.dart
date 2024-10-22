class TicketModel {
  final String? eventName,
      eventRound,
      startDate,
      endDate,
      eventDay,
      startTime,
      endTime,
      eventImageUrl,
      eventBackgroundImageUrl;
  final String? eventType, eventPlace, seatNumber, eventWebUrl, qrImageUrl;
  final bool isNew, isXive, isPurchase, audioExist;
  final int ticketId, eventId;

  TicketModel.fromJson(Map<String, dynamic> json)
      : isNew = json['isNew'],
        ticketId = json['ticketId'],
        eventId = json['eventId'],
        eventName = json['eventName'],
        eventRound = json['eventRound'],
        startDate = json['startDate'],
        endDate = json['endDate'],
        eventDay = json['eventDay'],
        startTime = json['startTime'],
        endTime = json['endTime'],
        eventImageUrl = json['eventImageUrl'],
        eventBackgroundImageUrl = json['eventBackgroundImageUrl'],
        eventType = json['eventType'],
        eventPlace = json['eventPlace'],
        seatNumber = json['seatNumber'],
        eventWebUrl = json['eventWebUrl'],
        isXive = json['isXive'],
        isPurchase = json['isPurchase'],
        qrImageUrl = json['qrImageUrl'],
        audioExist = json['audioExist'];
}
