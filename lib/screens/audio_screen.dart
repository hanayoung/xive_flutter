import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:xive/controllers/audio_controller.dart';
import 'package:xive/controllers/audio_play_controller.dart';
import 'package:xive/widgets/audio/audio_card.dart';

import '../widgets/audio/audio_header.dart';

final appBarTextStyle = TextStyle(color: Get.isDarkMode?Colors.white:Colors.black, fontSize: 16, fontFamily: 'Pretendard', fontWeight: FontWeight.w400, letterSpacing: -0.32,);

class AudioScreen extends StatelessWidget {
  const AudioScreen({super.key});

  @override
  Widget build(BuildContext context) {

    AudioController.to.buildContext = context;
    AudioPlayController.to.buildContext = context;

    return GetBuilder<AudioController>(builder: (c) {
      return Scaffold(
        body: Stack(
          children: [
             c.audioHeaderContents["eventBackgroundImageUrl"] != ""?
            Image.network(
              c.audioHeaderContents["eventBackgroundImageUrl"].toString(),
              height: double.infinity,
              fit: BoxFit.fitHeight,
            ): Get.isDarkMode?Container(color: Colors.black):Container(color: Colors.white,),
            Scaffold(
              backgroundColor: Get.isDarkMode?Colors.black.withOpacity(0.8):Colors.white.withOpacity(0.8),
              appBar: AppBar(
                  backgroundColor: Colors.transparent, iconTheme: IconThemeData(color: Get.isDarkMode?Colors.white:Colors.black),
                  title: Text("오디오 가이드",style: appBarTextStyle),
                leading: IconButton(onPressed: (){
                  AudioPlayController.to.endPlayer();
                  Get.back();
                }, icon: const Icon(Icons.chevron_left)),
                ),
                body: SafeArea(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        AudioHeader(),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: c.playList.length,
                                      itemBuilder: (context,index){
                                        return AudioCard(index: index);
                                      }
                                  )

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