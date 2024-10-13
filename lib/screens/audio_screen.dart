
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:xive/controllers/audio_controller.dart';
import 'package:xive/routes/pages.dart';

const appBarTextStyle = TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Pretendard', fontWeight: FontWeight.w400, height: 0.09, letterSpacing: -0.32,);

const audioHeaderSubTitle = TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Pretendard', fontWeight: FontWeight.w400, height: 0, letterSpacing: -0.32,);
const audioHeaderTitle = TextStyle(color: Colors.white, fontSize: 22, fontFamily: 'Pretendard', fontWeight: FontWeight.w700, height: 0, letterSpacing: -0.44,);
const audioHeaderStatistics = TextStyle(color: Color(0xFF9E9E9E), fontSize: 14, fontFamily: 'Pretendard', fontWeight: FontWeight.w400, height: 0.11, letterSpacing: -0.28,);

const playCardTextStyle = TextStyle(color: Color(0xFFDFDFDF), fontSize: 16, fontFamily: 'Pretendard', fontWeight: FontWeight.w400, height: 0.09, letterSpacing: -0.32,);

class AudioScreen extends StatelessWidget {
  const AudioScreen({super.key});

  Widget playCard(int index, String title){
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: (){
          Get.toNamed(Routes.audioPlay);
        },
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset("assets/images/app_icon.png", height: 56, width: 56,), // Text(key['title']),
            ),
            const SizedBox(width: 8,),
            Expanded(child:Text(
              '${index}.  ${title}',
              style: playCardTextStyle,
            ),)
          ],
        ),
      ),
    );
  }

  Widget audioHeader(){

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AudioController.to.audioHeader["subTitle"], style: audioHeaderSubTitle ,),
          Text(AudioController.to.audioHeader["title"], style:audioHeaderTitle ,),
          const SizedBox(height: 12,),
          Row(
            children: [
              Text(
                '총 ${AudioController.to.audioHeader["count"]}작품',
                style: audioHeaderStatistics
              ),
              const SizedBox(
                width: 6,
              ),
              const Text("|", style: audioHeaderStatistics,),
              const SizedBox(width: 6,),
              Text(
                '${AudioController.to.audioHeader["time"]}분',
                style: audioHeaderStatistics,
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    AudioController.to.buildContext = context;

    return GetBuilder<AudioController>(builder: (c) {
      return Scaffold(
        body: Stack(
          children: [
            Image.network(c.backGroundImage, height: double.infinity, fit: BoxFit.fill,),
            Scaffold(
              backgroundColor: Color(0xE0000000),
              appBar: AppBar(
                  backgroundColor: Colors.transparent, iconTheme: const IconThemeData(color: Colors.white,),
                  title: const Text("오디오 가이드",style: appBarTextStyle),
                ),
                body: SafeArea(
                  child: SingleChildScrollView(
                    physics: NeverScrollableScrollPhysics(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          audioHeader(),
                          Column(
                            children: [
                              ListView(

                                shrinkWrap: true,
                                children: [
                                  for(int i=0; i<c.playList.length; i++)
                                    playCard(i, c.playList[i]["title"]),
                                ],
                              ),
                            ],
                          ),
                          // playCard(1, "붉은 꽃 그림")
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );

    });
    
  }
}