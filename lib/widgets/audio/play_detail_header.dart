
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:xive/controllers/audio_play_controller.dart';


class PlayDetailHeader extends StatelessWidget {
  const PlayDetailHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AudioPlayController>(builder: (c){
        return Obx(
              () => Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        c.isSubtitle.value ? Row(
                          children: [
                            Image.network(c.audioImageUrl.value, height: 57, width: 57, fit: BoxFit.fitWidth,),
                            SizedBox(width: 12,)
                          ],
                        ):Container(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              c.audioName.value,
                              style: TextStyle(color: Get.isDarkMode?Colors.white:Colors.black, fontSize: 20, fontFamily: 'Pretendard', fontWeight: FontWeight.w600, letterSpacing: -0.40,),
                            ),
                            Text(
                              c.audioArtist.value,
                              style: TextStyle(color:Get.isDarkMode?Colors.white:Colors.black, fontSize: 16, fontFamily: 'Pretendard', fontWeight: FontWeight.w400, letterSpacing: -0.32,) ,
                            ),
                          ],
                        ),
                      ],
                    ),
                    InkWell(
                        onTap: (){
                          Get.back();
                        }, child: SvgPicture.asset(Get.isDarkMode?"assets/images/Expand_down_dark.svg":"assets/images/Expand_down_light.svg", width: 24, height: 24, fit: BoxFit.fitHeight,)
                    )
                  ],
                ),
                SizedBox(height: 8,),
                //TODO
                for(int i=0; i<c.audioDescription.length; i++)
                  c.isSubtitle.value?Container():Text(
                    c.audioDescription[i],
                    style: TextStyle(color: Get.isDarkMode?Colors.white.withOpacity(0.7):Colors.black.withOpacity(0.7), fontSize: 14, fontFamily: 'Pretendard', fontWeight: FontWeight.w400, letterSpacing: -0.28,),
                  )
              ],
            ),
          ),
        );
    });
  }
}
