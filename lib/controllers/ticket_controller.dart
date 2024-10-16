import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'package:xive/controllers/splash_controller.dart';
import 'package:xive/models/event_model.dart';
import 'package:xive/services/event_service.dart';
import 'package:xive/utils/bottom_sheet_modal.dart';

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

  late BuildContext _buildContext;

  final SplashController viewModel = SplashController.to;

  set buildContext(BuildContext context) {
    _buildContext = context;
  }

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

  Future<void> readNfc() async {
    //nfc 사용이 가능한지 확인
    bool isAvailable = await NfcManager.instance.isAvailable();

    //nfc 사용이 불가능한 경우
    if (!isAvailable) {
      if (Platform.isAndroid) {
        AppSettings.openAppSettings(type: AppSettingsType.nfc);
      }
      return;
    } else {
      if (Platform.isAndroid) {
        show(_buildContext);
      }
    }
    await nfcRead();
  }

  Future<void> nfcRead() async {
    NfcManager.instance.startSession(
      onError: (NfcError error) {
        //에러 시 세션 멈춤
        return NfcManager.instance.stopSession(alertMessage: "NFC_SCAN_FAIL");
      },
      onDiscovered: (NfcTag tag) async {
        String id = getNfcId(tag);
        String? decodedNfcMessage = getDecodedNfcMessage(tag);
        if (decodedNfcMessage != null) {
          EventModel data = await EventService().getEventData(
              viewModel.accessToken.value!,
              viewModel.refreshToken.value!,
              decodedNfcMessage);
          TicketModel ticketInstance = await TicketService().postTicket(
              viewModel.accessToken.value!,
              viewModel.refreshToken.value!,
              data.eventId);
          if (ticketInstance.isNew) {
            ticketList.add(ticketInstance);
          }
        }
        if (Platform.isIOS) {
          NfcManager.instance.stopSession(alertMessage: "NFC_SCAN_SUCCESS");
        }
      },
    );
  }

  String getNfcId(NfcTag tag) {
    //ios 일 경우
    if (Platform.isIOS) {
      var mifare = MiFare.from(tag);
      return mifare!.identifier
          .map((e) => e.toRadixString(16).padLeft(2, '0'))
          .join('');
    } else {
      //android 일 경우
      Ndef? ndef = Ndef.from(tag);
      return ndef?.additionalData['identifier']
          .map((e) => e.toRadixString(16).padLeft(2, '0'))
          .join('');
    }
  }

  String? getDecodedNfcMessage(NfcTag tag) {
    Ndef? ndef = Ndef.from(tag);
    NdefMessage? nfcMessage = ndef?.cachedMessage;
    NdefRecord? urlData = nfcMessage?.records.firstOrNull;
    if (urlData != null) {
      Uint8List uint8ListData = Uint8List.fromList(urlData.payload);
      return utf8.decode(uint8ListData.sublist(3));
    } else {
      return null;
    }
  }

  @override
  void onInit() {
    _setTicketList();
    super.onInit();
  }
}
