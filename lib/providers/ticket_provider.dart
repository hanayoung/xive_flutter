// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:xive/models/ticket_model.dart';
// import 'package:xive/services/ticket_service.dart';
//
// class TicketProvider extends ChangeNotifier {
//   static const storage = FlutterSecureStorage();
//
//   bool _hasTicket = false;
//   bool get hasTicket => _hasTicket;
//
//   List<TicketModel> _ticketList = [];
//   List<TicketModel> get ticketList => _ticketList;
//
//   String _bgImgUrl = "";
//   String get bgImgUrl => _bgImgUrl;
//
//   TicketProvider() {
//     setTicketList();
//   }
//
//   Future<void> setTicketList() async {
//     final accessToken = await storage.read(key: 'access_token');
//     final refreshToken = await storage.read(key: 'refresh_token');
//     if (accessToken != null && refreshToken != null) {
//       // print("accessToken $accessToken refreshToken $refreshToken");
//       _ticketList =
//           await TicketService().getAllTickets(accessToken, refreshToken);
//       _hasTicket = true;
//       // print("ticket $ticketList");
//       _bgImgUrl = _ticketList[0].eventBackgroundImageUrl!;
//       notifyListeners();
//     }
//   }
//
//   setBgImg(int index) {
//     _bgImgUrl = ticketList[index].eventBackgroundImageUrl!;
//     print("change bgImg");
//     notifyListeners();
//   }
// }
