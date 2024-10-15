import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:xive/controllers/audio_controller.dart';
import 'package:intl/intl.dart';


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

  RxBool isPlay = false.obs;
  RxBool isSubtitle = false.obs;

  Rx<String> audioImageUrl = "".obs;
  Rx<String> audioSoundUrl = "".obs;
  Rx<String> audioName = "".obs;
  Rx<String> audioArtist = "".obs;
  var audioDescription = [].obs;

  final player = AudioPlayer();
  var duration;

  var speedValue = 1.0.obs;

  // player.play();                                  // Play without waiting for completion
  // await player.play();                            // Play while waiting for completion
  // await player.pause();                           // Pause but remain ready to play
  // await player.seek(Duration(second: 10));        // Jump to the 10 second position
  // await player.setSpeed(2.0);                     // Twice as fast
  // await player.setVolume(0.5);                    // Half as loud
  // await player.stop();


  Future<void> updatePlay(index) async{

    audioImageUrl.value = AudioController.to.playList[index]["audioImageUrl"];
    audioName.value = AudioController.to.playList[index]["audioName"];
    audioSoundUrl.value = 'https://ccrma.stanford.edu/~jos/mp3/harpsi-cs.mp3';
    audioArtist.value = "Michel Henry";

    audioDescription.value = ['2011, 캔버스에 아크릴릭, 펜, 국립현대미술관 소장',  '국립현대미술관 발전 후원위원회 기증 '];
    duration = await player.setUrl(audioSoundUrl.value);
    // await player.play();
    isPlay.value = false;
    isSubtitle.value = false;
  }

  updateIsPlay(){
    isPlay.value = !isPlay.value;

    if(isPlay.value){
      player.play();
    }else{
      player.pause();
    }

  }

  nextPlayList() async{
    AudioController.to.playIndex.value += 1;
    await updatePlay(AudioController.to.playIndex.value);
    updateIsPlay();

    AudioController.to.update();
    update();
  }

  beforePlayList() async{
    AudioController.to.playIndex.value -= 1;
    await updatePlay(AudioController.to.playIndex.value);
    updateIsPlay();

    AudioController.to.update();
    update();
  }

  updatePlaySpeed(double value) async{
    speedValue.value = value;
    await player.setSpeed(speedValue.value);
    update();
  }

  Widget playUnderBar(BuildContext context){
    return Obx( () => Container(
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 8),
      // color: Colors.white,
      child: Column(
        children: [
          AudioPlayController.to.musicProgressBar(),
          InkWell(
            onTap: ()  {
              showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  // useSafeArea: true,
                  builder: (BuildContext context) {
                    return AudioPlayController.to.playDetailWidget();
                  });
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                    // mainAxisSize: MainAxisSize.min,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: AudioPlayController.to.audioImageUrl != "" ?
                        Image.network(AudioPlayController.to.audioImageUrl.value,height: 32, width: 32, fit: BoxFit.fill,):
                        Image.asset("assets/images/audio_example.png", height: 32, width: 32, fit: BoxFit.fill,),
                      ),
                      const SizedBox(width: 8,),
                      Expanded(
                        child: Text(
                          '${AudioPlayController.to.audioName}',
                          style: const TextStyle(color: Color(0xFFDFDFDF), fontSize: 16, fontFamily: 'Pretendard', fontWeight: FontWeight.w400,letterSpacing: -0.32,),
                        ),),
                    ],
                  ),
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: (){
                        beforePlayList();
                      },
                      child: Image.asset("assets/images/stop_and_play_light_left.png", width: 32, height: 32, fit: BoxFit.fitHeight,),
                    ),
                    InkWell(
                      onTap: (){
                        updateIsPlay();
                      },
                      child: AudioPlayController.to.isPlay.value ? Image.asset("assets/images/stop_light.png", width: 32, height: 32, fit: BoxFit.fitHeight):Image.asset("assets/images/play_vector.png", width: 32, height: 32, fit: BoxFit.fitHeight,),
                    ),
                    InkWell(
                      onTap: () {
                        nextPlayList();
                      },
                      child: Image.asset("assets/images/stop_and_play_light_right.png", width: 32, height: 32,fit: BoxFit.fitHeight),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }

  Widget playDetailHeader(){
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      audioName.value,
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'Pretendard', fontWeight: FontWeight.w600, letterSpacing: -0.40,),
                    ),
                    Text(
                      audioArtist.value,
                      style: const TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Pretendard', fontWeight: FontWeight.w400, letterSpacing: -0.32,),
                    ),
                  ],
                ),
                InkWell(
                  onTap: (){
                    Get.back();
                  }, child: Image.asset("assets/images/Expand_down_light.png", width: 24, height: 24, fit: BoxFit.fitHeight,)
                )
              ],
            ),
            for(int i=0; i<audioDescription.length; i++)
              Text(
                audioDescription[i],
                style: TextStyle(color: Colors.white.withOpacity(0.699999988079071), fontSize: 14, fontFamily: 'Pretendard', fontWeight: FontWeight.w400, letterSpacing: -0.28,),
              )
          ],
        ),
      ),
    );
  }


  Widget PlayTool(){
    return Container(
        height: 220,
        padding: const EdgeInsets.fromLTRB(0,24,0,0),
        child: Column(
          children: [
            musicProgressBar(),
            const SizedBox( height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: (){

                  }, child: Image.asset("assets/images/10_seconds_before.png", width: 32, height: 32, fit: BoxFit.fitHeight,)
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () async{
                        beforePlayList();
                      }, child: Image.asset("assets/images/stop_and_play_light_left.png", width: 32, height: 32, fit: BoxFit.fitHeight,)
                    ),
                    Obx(() => InkWell(
                          onTap: (){
                            updateIsPlay();
                          },child: isPlay.value? Image.asset("assets/images/stop_light.png", width: 54, height: 54, fit: BoxFit.fitHeight,)
                        :Image.asset("assets/images/play_vector.png", width: 54, height: 54, fit: BoxFit.fitHeight,)
                      ),
                    ),
                    InkWell(onTap:() {
                      nextPlayList();
                    },child: Image.asset("assets/images/stop_and_play_light_right.png", width: 32, height: 32, fit: BoxFit.fitHeight,)
                    )
                  ],
                ),
                InkWell(
                    onTap: () {

                    },child: Image.asset("assets/images/10_seconds_after.png", width: 32, height: 32, fit: BoxFit.fitHeight,)
                )
              ],
            ),
            const SizedBox(height: 71,),
            Row(
              mainAxisAlignment:MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: (){
                      showDialog(
                          context: _buildContext,
                          builder: (context){
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Obx(
                              () => Container(
                                height: 70,
                                padding: EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                    color: Color(0xFF222222),
                                    borderRadius: BorderRadius.circular(4)
                                ),
                                child: SfSliderTheme(
                                  data: const SfSliderThemeData(
                                    activeTrackHeight:1.5,
                                    inactiveTrackHeight : 1.5,
                                    thumbRadius:7,
                                    labelOffset: Offset(0.0, 10),
                                    activeLabelStyle: TextStyle(color: Colors.white, fontSize: 10, fontFamily: 'Pretendard', fontWeight: FontWeight.w500, letterSpacing: -0.20,),
                                    inactiveLabelStyle: TextStyle(color: Colors.white, fontSize: 10, fontFamily: 'Pretendard', fontWeight: FontWeight.w500, letterSpacing: -0.20,),
                                  ),
                                  child: SfSlider(
                                      min: 0.5,
                                      max: 1.5,
                                      value: speedValue.value,
                                      showLabels: true,
                                      enableTooltip: false,
                                      interval: 0.25,
                                      stepSize: 0.25,
                                      activeColor: Colors.white,
                                      inactiveColor: Colors.white24.withOpacity(0.5),
                                      labelFormatterCallback: (dynamic actualValue, String formattedText) {
                                        return actualValue.toString()+"x";
                                      },
                                      onChanged: (value){
                                        updatePlaySpeed(value);
                                      }),
                                )

                              ),
                            ),
                          ),
                        );
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/play_speed.png", width: 24, height: 24, fit: BoxFit.fitHeight,),
                        const SizedBox(width: 5,),
                        Text(
                          '재생 속도 (x1)',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                            height: 0.24,
                            letterSpacing: -0.20,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: (){
                      isSubtitle.value = ! isSubtitle.value;
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset("assets/images/play_subtitle.png", width: 24, height: 24, fit: BoxFit.fitHeight,),
                        const SizedBox(width: 5,),
                        const Text(
                          '자막 보기',
                          style: TextStyle(color: Colors.white, fontSize: 10, fontFamily: 'Pretendard', fontWeight: FontWeight.w500, letterSpacing: -0.20,),
                        )
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ));
  }


  Widget playDetailWidget(){
    return Stack(
        children: [
          Image.network(audioImageUrl.value, width: double.infinity, height: double.infinity, fit: BoxFit.fill,),
          Container(
            color: Color(0xCC000000),
            child: SafeArea(
              child: Container(
                padding: EdgeInsets.fromLTRB(24, AppBar().preferredSize.height, 24,0),
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children:[
                                Container(
                                    padding:EdgeInsets.symmetric(vertical: 24),
                                    child: playDetailHeader()
                                ),
                                Obx(()=>Expanded(
                                    child: isSubtitle == false?
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(audioImageUrl.value, width: double.infinity, fit: BoxFit.fitWidth,),
                                    ): ListView(
                                      shrinkWrap: true,
                                      children: [
                                        Text(
                                          '#1. 작품소개',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.5),
                                            fontSize: 20,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: -0.40,
                                          ),
                                        ),
                                        SizedBox(height: 26,),
                                        Text(
                                          '예술은 단순한 표현이 아니라, 영혼의 깊이를 탐험하는 과정입니다.',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.5),
                                            fontSize: 20,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: -0.40,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ]
                          ),

                      ),
                      PlayTool()
                    ]),
              ),
            ),
          )
        ]
    );
  }

  Widget musicProgressBar(){
    return ProgressBar(
      progress: Duration(milliseconds: 1000),
      buffered: Duration(milliseconds: 2000),
      total: Duration(milliseconds: 5000),
      progressBarColor: Colors.white,
      baseBarColor: Colors.white.withOpacity(0.24),
      bufferedBarColor: Colors.white.withOpacity(0.24),
      thumbColor: Colors.white,
      barHeight: 3.0,
      thumbRadius: 0.0,
      onSeek: (duration) {

      },
    );
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    update();
  }

}
