import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  String backGroundImage = "";

  var audioHeader = {}.obs;
  var playList = [].obs;

  void initAudioHeader(){
    audioHeader["subTitle"] = "국립현대미술관 제 1전시장";
    audioHeader["title"] = "위대한 컬러리스트 《미셸 앙리》";
    audioHeader["count"] = 14;
    audioHeader["time"] = 20;
  }

  void initPlayList(){
    playList.value = [{"title":"붉은 꽃 그림"}, {"title":"붉은 꽃 그림"}, {"title":"붉은 꽃 그림"}, {"title":"붉은 꽃 그림"},{"title":"붉은 꽃 그림"},{"title":"붉은 꽃 그림"},{"title":"붉은 꽃 그림"},{"title":"붉은 꽃 그림"},{"title":"붉은 꽃 그림"},{"title":"붉은 꽃 그림"}];
  }

  void updateBackGroundImage(){
    backGroundImage = "https://mblogthumb-phinf.pstatic.net/20120615_30/snaps1_1339721440666NgJXG_JPEG/%BA%B0%BB%E7%C1%F8%C0%DF%C2%EF%B4%C2%B9%FD%B9%E3%BE%DF%B0%E6%BB%E7%C1%F8%C0%DF%C2%EF%B4%C2%B9%FD.jpg?type=w420";
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    initAudioHeader();
    initPlayList();
    updateBackGroundImage();
    update();
  }

}