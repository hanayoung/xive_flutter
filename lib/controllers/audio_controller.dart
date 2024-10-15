import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xive/screens/audio_screen.dart';
import 'package:xive/services/audio_service.dart';

import 'audio_play_controller.dart';

class AudioController extends GetxController {

  static AudioController get to {
    if (Get.isRegistered<AudioController>()) {
      return Get.find();
    }
    return Get.put(AudioController());
  }

  late BuildContext _buildContext;

  set buildContext(BuildContext context) {
    _buildContext = context;
  }


  var audioHeaderContents = {
    "eventPlace":"eventPlace",
    "eventName":"eventName",
    "eventBackgroundImageUrl":"eventBackgroundImageUrl",
    "audioCount": 0,
    "runningTime":0
  }.obs;


  var playList = [].obs;
  RxInt playIndex = 0.obs;
  RxBool isPlayBar = false.obs;

  void changePlayIndex(int index) async{
    if(isPlayBar.value == false){
      isPlayBar.value = true;
    }

    await AudioPlayController.to.updatePlay(index);

    AudioPlayController.to.updateIsPlay();
    playIndex.value = index;

    update();
  }


  Widget audioHeader(){

    return Obx(()=>Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            audioHeaderContents["eventPlace"].toString(),
            style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Pretendard', fontWeight: FontWeight.w400, letterSpacing: -0.32,) ,),
          Text(
            audioHeaderContents["eventName"].toString(),
            style: TextStyle(color: Colors.white, fontSize: 22, fontFamily: 'Pretendard', fontWeight: FontWeight.w700, letterSpacing: -0.44,) ,),
          const SizedBox(height: 12,),
          Row(
            children: [
              Text(
                  '총 ${audioHeaderContents["audioCount"]}작품',
                  style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14, fontFamily: 'Pretendard', fontWeight: FontWeight.w400, letterSpacing: -0.28,)
              ),
              const SizedBox(
                width: 6,
              ),
              const Text("|", style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14, fontFamily: 'Pretendard', fontWeight: FontWeight.w400, letterSpacing: -0.28,),),
              const SizedBox(width: 6,),
              Text(
                '${audioHeaderContents["runningTime"]}분',
                style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14, fontFamily: 'Pretendard', fontWeight: FontWeight.w400, letterSpacing: -0.28,),
              )
            ],
          )
        ],
      ),
    ));
  }
  void initEventAudio() async{
    var data = await AudioService().getEventAudio(51);
    AudioPlayController.to.isPlay.value = false;
    initAudioHeader(data);
    initPlayList(data);
  }

  void initAudioHeader(var data){

    audioHeaderContents["eventPlace"] = data["eventPlace"];
    audioHeaderContents["eventName"] = data["eventName"];
    audioHeaderContents["eventBackgroundImageUrl"]=data["eventBackgroundImageUrl"];
    audioHeaderContents["audioCount"] = data["audioCount"];
    audioHeaderContents["runningTime"] = data["runningTime"];
  }

  void initPlayList(var data){
    var audioCoreResponse = data["audioCoreResponse"];

    audioCoreResponse.forEach((element){
      playList.value.add({
        "audioImageUrl": element["audioImageUrl"],
        "audioSoundUrl": element["audioSoundUrl"],
        "audioName": element["audioName"]
      });
    });

    update();

  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initEventAudio();
    update();
  }

}