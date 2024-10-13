import 'package:flutter/material.dart';
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

  late BuildContext _buildContext;

  set buildContext(BuildContext context) {
    _buildContext = context;
  }

  static const storage = FlutterSecureStorage();

  Rx<bool> hasTicket = false.obs;

  List<TicketModel> ticketList = [];

  final Rx<String> _bgImgUrl = "".obs;
  String get bgImgUrl => _bgImgUrl.value;

  Future<void> setTicketList() async {
    final accessToken = await storage.read(key: 'access_token');
    final refreshToken = await storage.read(key: 'refresh_token');
    if (accessToken != null && refreshToken != null) {
      ticketList =
          await TicketService().getAllTickets(accessToken, refreshToken);
      if (ticketList.isNotEmpty) {
        hasTicket.value = true;
        _bgImgUrl.value = ticketList[0].eventBackgroundImageUrl!;
      }

      update();
    }
  }

  setBgImg(int index) {
    _bgImgUrl.value = ticketList[index].eventBackgroundImageUrl!;
    update();
  }

  @override
  void onInit() {
    setTicketList();
    super.onInit();
  }
}
