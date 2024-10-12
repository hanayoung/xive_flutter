import 'package:xive/models/ticket_model.dart';

class TicketListModel {
  final List<TicketModel> ticketList;

  TicketListModel.fromJson(Map<String, dynamic> json)
      : ticketList = (json['data'] as List)
            .map((item) => TicketModel.fromJson(item))
            .toList();
}
