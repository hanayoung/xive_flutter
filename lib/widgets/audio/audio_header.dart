
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xive/controllers/audio_controller.dart';

class AudioHeader extends StatelessWidget {
  const AudioHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AudioController>(builder: (c){
      return Obx(()=>Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              c.audioHeaderContents["eventPlace"].toString(),
              style: TextStyle(color: c.getColorWithDarkMode() , fontSize: 16, fontFamily: 'Pretendard', fontWeight: FontWeight.w400, letterSpacing: -0.32,) ,),
            Text(
              c.audioHeaderContents["eventName"].toString(),
              style: TextStyle(color: c.getColorWithDarkMode(), fontSize: 22, fontFamily: 'Pretendard', fontWeight: FontWeight.w700, letterSpacing: -0.44,) ,),
            const SizedBox(height: 12,),
            Row(
              children: [
                Text(
                    '총 ${c.audioHeaderContents["audioCount"]}작품',
                    style: TextStyle(color: Get.isDarkMode?Color(0xFF9E9E9E):Color(0xFF636363), fontSize: 14, fontFamily: 'Pretendard', fontWeight: FontWeight.w400, letterSpacing: -0.28,)
                ),
                const SizedBox(
                  width: 6,
                ),
                Text("|", style: TextStyle(color: Get.isDarkMode?Color(0xFF9E9E9E):Color(0xFF636363), fontSize: 14, fontFamily: 'Pretendard', fontWeight: FontWeight.w400, letterSpacing: -0.28,),),
                const SizedBox(width: 6,),
                Text(
                  '${c.audioHeaderContents["runningTime"]}분',
                  style: TextStyle(color: Get.isDarkMode?Color(0xFF9E9E9E):Color(0xFF636363), fontSize: 14, fontFamily: 'Pretendard', fontWeight: FontWeight.w400, letterSpacing: -0.28,),
                )
              ],
            )
          ],
        ),
      ));
    });
  }
}
