import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/platform_tags.dart';
import 'package:provider/provider.dart';
import 'package:xive/providers/ticket_provider.dart';
import 'package:xive/utils/bottom_sheet_modal.dart';
import 'package:xive/widgets/home_ticket.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static const storage = FlutterSecureStorage();

  Future<void> readNfc(BuildContext context) async {
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
        show(context);
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

  @override
  Widget build(BuildContext context) {
    final bgInfo = context.watch<TicketProvider>().bgImgUrl;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: Colors.white,
              height: 56,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Navigator.pushNamed(context, '/setting'),
                    child: SvgPicture.asset(
                      'assets/images/home_setting_icon.svg',
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/images/home_xive_icon.svg',
                  ),
                  SvgPicture.asset(
                    'assets/images/home_calendar_icon.svg',
                  ),
                ],
              ),
            ),
            Consumer<TicketProvider>(builder: (context, value, child) {
              if (value.hasTicket == false) {
                return Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment(0, -0.2), // 그라데이션의 중심
                        radius: 0.5, // 그라데이션의 반경
                        colors: [
                          Color(0xFFB5B5B5), // 중간이 진한 색상
                          Color(0xFFFFFFFF), // 위아래로 갈수록 연한 색상
                        ],
                        stops: [0.2, 1.0], // 색상이 변화하는 지점 (0.5 = 중간, 1.0 = 끝)
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/home_no_card_img.png',
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        const Text.rich(
                          textAlign: TextAlign.center,
                          TextSpan(
                              text: 'Add +\n',
                              style: TextStyle(
                                color: Color(0xFF8000FF),
                                fontSize: 32,
                                letterSpacing: -0.02,
                                fontWeight: FontWeight.w600,
                                height: 26 / 32,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: 'Smart ticket',
                                  style: TextStyle(
                                    color: Color(0xFF000000),
                                    fontSize: 32,
                                    letterSpacing: -0.02,
                                    fontWeight: FontWeight.w600,
                                    height: 26 / 32,
                                  ),
                                )
                              ]),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        const Text(
                          '스마트 티켓을 등록해주세요',
                          style: TextStyle(
                            color: Color(0xFF636363),
                            fontSize: 16,
                            letterSpacing: -0.02,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(bgInfo),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: HomeTicket(ticketList: value.ticketList)),
                );
              }
            }),
          ],
        ),
      ),
      floatingActionButton: Transform.scale(
        scale: 1.3,
        child: FloatingActionButton(
          onPressed: () => readNfc(context),
          elevation: 0,
          backgroundColor: Colors.white.withOpacity(0),
          child: Image.asset(
            'assets/images/home_nfc_icon_black.png',
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
