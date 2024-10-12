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

  //원래 쓰면 안됌. 옮기기 위해서 임시
  BuildContext getBuildContext(){
    return _buildContext;
  }

  static const storage = FlutterSecureStorage();

  Future<void> readNfc(HomeController controller) async {
    //nfc 사용이 가능한지 확인
    bool isAvailable = await NfcManager.instance.isAvailable();

    //nfc 사용이 불가능한 경우
    if (!isAvailable) {
      if (Platform.isAndroid) {
        AppSettings.openAppSettings(type: AppSettingsType.nfc);
        //android 일 경우 nfc 설정창으로 이동 시킴
        //ios는 nfc가 os단에서 감지하고 실행되기 때문에 안드로이드처럼 설정창으로 보낼 수 없다.
      }
      //토스트 띄우기
      // ToastUtil.show(message: NFC_DISALBE_DEVICE_MESSAGE);
      return;
    } else {
      if (Platform.isAndroid) {
        show(HomeController.to.getBuildContext());
      }
    }
    await nfcRead();
  }

  Future<void> nfcRead() async {
    NfcManager.instance.startSession(
      //nfc 태그를 읽을 수 있는 타입을 지정한다.
      //타입에 따라 읽을 수 있는 nfc 태그가 달라진다. (iso14443는 교통카드, iso15693는 물류,재고관리 등에 쓰인다고 한다)
      //pollingOptions을 지정하지 않으면 모든 타입의 nfc 태그를 읽을 수 있다.
      //특정 태그만 읽어야 하는 기능은 아니라서 아래 줄은 필요 없을 것 같다.
      //pollingOptions: {NfcPollingOption.iso14443, NfcPollingOption.iso15693},
      //ios에서만 사용되는 옵션
      alertMessage: 'NFC_SCAN_MSG',
      onError: (NfcError error) {
        //에러 시 세션 멈춤
        return NfcManager.instance.stopSession(alertMessage: "NFC_SCAN_FAIL");
      },

      //nfc 태그를 읽었을 때
      onDiscovered: (NfcTag tag) async {
        //nfc id 가져오기
        String id = getNfcId(tag);
        //nfc 페이로드 가져오기
        String? decodedNfcMessage = getDecodedNfcMessage(tag);
        //ios만 세션 스탑 해줌
        //ios는 stop 안하면 팝업이 계속 뜸
        //android는 stop 하면 nfc가 연속적으로 읽힘
        if (Platform.isIOS) {
          NfcManager.instance.stopSession(alertMessage: "NFC_SCAN_SUCCESS");
        }
      },
    );
  }

  String getNfcId(NfcTag tag) {
    //ios 일 경우
    if (Platform.isIOS) {
      //Mifare는 ios 에서 사용되는 NFCMiFareTag 클래스에 접근하게 해줌
      var mifare = MiFare.from(tag);
      print("getNfcId $mifare");
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

//nfc 페이로드 가져오기
  String? getDecodedNfcMessage(NfcTag tag) {
    //ndef = NFC 데이터 교환에 이용되는 데이터 교환 포맷
    Ndef? ndef = Ndef.from(tag);
    print("nfd ndef $ndef");
    NdefMessage? nfcMessage = ndef?.cachedMessage;
    //ndef message > ndef record > header(record에 대한 기본정보) + payload(첫 바이트는 페이로드의 헤더, 나머지는 페이로드 데이터)
    //페이로드의 타입이 text/plain 인 것을 찾는다
    NdefRecord? urlData = nfcMessage?.records.firstOrNull;
    if (urlData != null) {
      Uint8List uint8ListData = Uint8List.fromList(urlData.payload);
      print("nfc list $uint8ListData");
      //페이로드의 첫 바이트는 페이로드의 헤더이므로 제외하고 utf8로 디코딩한다.
      return utf8.decode(uint8ListData.sublist(3));
    } else {
      return null;
    }
  }


}