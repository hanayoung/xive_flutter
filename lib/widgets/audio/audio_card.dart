import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:xive/controllers/audio_controller.dart';


class AudioCard extends StatelessWidget {
  int index;

  AudioCard({required this.index, Key? key}):super(key: key) ;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AudioController>(builder: (c){
      return Obx(() => Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: InkWell(
          onTap: (){
            c.changePlayIndex(index);
          },
          child: c.isPlayBar.value && c.playIndex.value == index?
          Row(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    //TODO
                    child: c.playList[index]["audioImageUrl"] != null ?
                    Image.network(AudioController.to.playList[index]["audioImageUrl"], height: 56, width: 56, fit: BoxFit.fill,)
                        : Container(
                        height: 56,
                        width: 56,
                        decoration: BoxDecoration(
                            color: Color(0xFF444444),
                            borderRadius: BorderRadius.circular(4)
                        )
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(5.0)
                    ),
                    width: 56,
                    height: 56,
                    child: Center(child: Image.asset("assets/images/play_vector.png")),
                  ),

                ],
              ),
              const SizedBox(width: 12,),
              Expanded(
                child:Text(
                  '${index+1}.  ${c.playList[index]["audioName"]}',
                  style: TextStyle(color: c.getColorWithDarkMode(),   fontSize: 16, fontFamily: 'Pretendard', fontWeight: FontWeight.w600, letterSpacing: -0.32,),
                ),
              )
            ],
          ): Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(5.0),
                //TODO
                child: c.playList[index]["audioImageUrl"] != null ?
                Image.network(c.playList[index]["audioImageUrl"], height: 56, width: 56, fit: BoxFit.fill,)
                    :SizedBox(width: 56, height: 56,
                  child: Stack(
                      children:[
                        Container(
                          height: 56,
                          width: 56,
                          decoration: BoxDecoration(
                              color: Color(0xFF444444),
                              borderRadius: BorderRadius.circular(4)
                          ),),
                        Center(child: SvgPicture.asset("assets/images/nonlogo.svg", height: 15, width: 15, fit: BoxFit.fill,)),
                      ] ),
                ),


              ),
              const SizedBox(width: 12,),
              Expanded(
                child:Text(
                  '${index+1}.  ${c.playList[index]["audioName"]}',
                  style: TextStyle(color: Get.isDarkMode?Color(0xFFDFDFDF):Colors.black, fontSize: 16, fontFamily: 'Pretendard', fontWeight: FontWeight.w400, letterSpacing: -0.32,),
                ),
              )
            ],
          ),
        ),
      ));
    });
  }
}
