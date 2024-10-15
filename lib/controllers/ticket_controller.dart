import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../models/ticket_model.dart';
import '../services/ticket_service.dart';

class TicketController extends GetxController {
  static TicketController get to {
    if (Get.isRegistered<TicketController>()) {
      return Get.find();
    }
    return Get.put(TicketController());
  }

  static const storage = FlutterSecureStorage();

  Rx<bool> hasTicket = false.obs;

  List<TicketModel> ticketList = [];

  final Rx<String> _bgImgUrl = "".obs;
  String get bgImgUrl => _bgImgUrl.value;

  Future<void> _setTicketList() async {
    final accessToken = await storage.read(key: 'access_token');
    final refreshToken = await storage.read(key: 'refresh_token');
    if (accessToken != null && refreshToken != null) {
      ticketList =
          await TicketService().getAllTickets(accessToken, refreshToken);
      if (ticketList.isNotEmpty) {
        hasTicket.value = true;
        _bgImgUrl.value = ticketList[0].eventBackgroundImageUrl!;
      }
    }
  }

  setBgImg(int index) {
    _bgImgUrl.value = ticketList[index].eventBackgroundImageUrl!;
  }

  @override
  void onInit() {
    _setTicketList();
    super.onInit();
  }
}
