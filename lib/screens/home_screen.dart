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
      }
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
      onError: (NfcError error) {
        //에러 시 세션 멈춤
        return NfcManager.instance.stopSession(alertMessage: "NFC_SCAN_FAIL");
      },

      //nfc 태그를 읽었을 때
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
    if (Platform.isIOS) {
      var mifare = MiFare.from(tag);
      return mifare!.identifier
          .map((e) => e.toRadixString(16).padLeft(2, '0'))
          .join('');
    } else {
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
          shape: const CircleBorder(),
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
