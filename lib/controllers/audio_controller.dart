import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xive/models/audio_model.dart';
import 'package:xive/models/audio_play_list_model.dart';
import 'package:xive/models/ticket_model.dart';
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
    "eventPlace":"",
    "eventName":"",
    "eventBackgroundImageUrl":"",
    "audioCount": 0,
    "runningTime":0
  }.obs;

  var playList = [].obs;

  RxInt playIndex = 0.obs;
  RxBool isPlayBar = false.obs;

  late TicketModel? ticketModel;

  void changePlayIndex(int index) async{

    if(isPlayBar.value == false){
      isPlayBar.value = true;
      AudioPlayController.to.updateIsPlay();
    }


    await AudioPlayController.to.updatePlay(index);

    playIndex.value = index;
    update();
  }

  getColorWithDarkMode(){
    return Get.isDarkMode?Colors.white:Colors.black;
  }



  void initEventAudio() async{
    //TODO
    var data = await AudioService().getEventAudio(ticketModel!.eventId);
    playList.clear();
    AudioPlayController.to.isPlay.value = false;
    _initAudioHeader(data);
    await _initPlayList(data);
    AudioPlayController.to.updatePlay(0);
    update();
  }

  void _initAudioHeader(var data){
    audioHeaderContents["eventPlace"] = data["eventPlace"];
    audioHeaderContents["eventName"] = data["eventName"];
    audioHeaderContents["audioCount"] = data["audioCount"];
    audioHeaderContents["runningTime"] = data["runningTime"];
    audioHeaderContents["eventBackgroundImageUrl"]=data["eventBackgroundImageUrl"];
  }

  Future<void> _initPlayList(var data) async{
    var audioCoreResponse = data["audioCoreResponse"];

    await audioCoreResponse.forEach((element){
      playList.value.add({
        "audioId": element["audioId"],
        "audioImageUrl": element["audioImageUrl"],
        "audioSoundUrl":element["audioSoundUrl"],
        "audioName": element["audioName"],
        "audioArtist": element["audioArtist"]
      });

    });

    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }

}