import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xive/controllers/audio_controller.dart';
import 'package:xive/controllers/audio_play_controller.dart';

const appBarTextStyle = TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Pretendard', fontWeight: FontWeight.w400, letterSpacing: -0.32,);

class AudioScreen extends StatelessWidget {
  const AudioScreen({super.key});

  Widget playCard(int index){
    return Obx(() => Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: (){
          AudioController.to.changePlayIndex(index);
        },
        child: AudioController.to.isPlayBar.value && AudioController.to.playIndex == index?
        Row(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: AudioController.to.playList[index]["audioImageUrl"] != null ?
                  Image.network(AudioController.to.playList[index]["audioImageUrl"], height: 56, width: 56, fit: BoxFit.fill,)
                      :Image.asset("assets/images/audio_example.png", height: 56, width: 56, fit: BoxFit.fill,),
                ),
                Container(
                  color: Colors.black.withOpacity(0.6),
                  width: 56,
                  height: 56,
                  child: Center(child: Image.asset("assets/images/play_vector.png")),
                ),

              ],
            ),
            const SizedBox(width: 8,),
            Expanded(
              child:Text(
                '${index+1}.  ${AudioController.to.playList[index]["audioName"]}',
                style: const TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Pretendard', fontWeight: FontWeight.w600, letterSpacing: -0.32,),
              ),
            )
          ],
        ): Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: AudioController.to.playList[index]["audioImageUrl"] != null ?
              Image.network(AudioController.to.playList[index]["audioImageUrl"], height: 56, width: 56, fit: BoxFit.fill,)
                  :Image.asset("assets/images/audio_example.png", height: 56, width: 56, fit: BoxFit.fill,),
            ),
            const SizedBox(width: 8,),
            Expanded(
              child:Text(
              '${index+1}.  ${AudioController.to.playList[index]["audioName"]}',
              style: const TextStyle(color: Color(0xFFDFDFDF), fontSize: 16, fontFamily: 'Pretendard', fontWeight: FontWeight.w400, letterSpacing: -0.32,),
              ),
            )
          ],
        ),
      ),
    ));
  }





  @override
  Widget build(BuildContext context) {
    AudioController.to.buildContext = context;
    AudioPlayController.to.buildContext = context;

    return GetBuilder<AudioController>(builder: (c) {
      return Scaffold(
        body: Stack(
          children: [
            c.audioHeaderContents != null && c.audioHeaderContents["eventBackgroundImageUrl"] != null?
            Image.network(c.audioHeaderContents["eventBackgroundImageUrl"].toString(), height: double.infinity, fit: BoxFit.fitHeight,):
            Image.asset("assets/images/audio_example.png", height: double.infinity, fit: BoxFit.fitHeight,),
            Scaffold(
              backgroundColor: Color(0xCC000000),
              appBar: AppBar(
                  backgroundColor: Colors.transparent, iconTheme: const IconThemeData(color: Colors.white,),
                  title: const Text("오디오 가이드",style: appBarTextStyle),
                ),
                body: SafeArea(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            physics: NeverScrollableScrollPhysics(),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  c.audioHeader(),
                                  ListView(
                                    shrinkWrap: true,
                                    children: [
                                      for(int i=0; i<c.playList.length; i++)
                                        playCard(i),
                                    ],
                                  ),
                                ],
                              ),
                          ),
                        ),
                        Obx(() => c.isPlayBar.value == true ?
                        AudioPlayController.to.playUnderBar(context):Container()
                        )
                      ],
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