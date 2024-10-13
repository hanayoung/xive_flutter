
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xive/controllers/audio_play_controller.dart';

class AudioPlayScreen extends StatelessWidget {
  const AudioPlayScreen({super.key});

  Widget playHeader(){
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '붉은 꽃 그림',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
              height: 0.06,
              letterSpacing: -0.40,
            ),
          ),
          SizedBox(height: 2,),
          // Text(
          //   'Michel Henry',
          //   style: TextStyle(
          //     color: Colors.white,
          //     fontSize: 16,
          //     fontFamily: 'Pretendard',
          //     fontWeight: FontWeight.w400,
          //     height: 0.09,
          //     letterSpacing: -0.32,
          //   ),
          // ),
          // const SizedBox(height: 8,),
          // Text(
          //   '2011, 캔버스에 아크릴릭, 펜, 국립현대미술관 소장 국립현대미술관 발전 후원위원회 기증 ',
          //   style: TextStyle(
          //     color: Colors.white.withOpacity(0.699999988079071),
          //     fontSize: 14,
          //     fontFamily: 'Pretendard',
          //     fontWeight: FontWeight.w400,
          //     height: 0.10,
          //     letterSpacing: -0.28,
          //   ),
          // ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AudioPlayController.to.buildContext = context;

    return GetBuilder<AudioPlayController>(
        builder: (c) => Scaffold(
        body: Stack(
          children: [
            Image.network(c.playImage, height: double.infinity, fit: BoxFit.fill,),
            Scaffold(
              backgroundColor: Color(0xE0000000),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        playHeader()
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}
