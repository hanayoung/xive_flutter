import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';

import 'package:xive/utils/bottom_sheet_modal.dart';

class HomeController extends GetxController {
  static HomeController get to {
    if (Get.isRegistered<HomeController>()) {
      return Get.find();
    }
    return Get.put(HomeController());
  }

  late BuildContext _buildContext;

  set buildContext(BuildContext context) {
    _buildContext = context;
  }

  static const storage = FlutterSecureStorage();

  Future<void> readNfc(HomeController controller) async {
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
}
