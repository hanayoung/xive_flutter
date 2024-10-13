
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AudioPlayController extends GetxController{
  static AudioPlayController get to {
    if (Get.isRegistered<AudioPlayController>()) {
      return Get.find();
    }
    return Get.put(AudioPlayController());
  }

  late BuildContext _buildContext;

  set buildContext(BuildContext context) {
    _buildContext = context;
  }

  String playImage = "";

  void updatePlayImage(){
    playImage = "https://mblogthumb-phinf.pstatic.net/20120615_30/snaps1_1339721440666NgJXG_JPEG/%BA%B0%BB%E7%C1%F8%C0%DF%C2%EF%B4%C2%B9%FD%B9%E3%BE%DF%B0%E6%BB%E7%C1%F8%C0%DF%C2%EF%B4%C2%B9%FD.jpg?type=w420";
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    updatePlayImage();
    update();
  }

}