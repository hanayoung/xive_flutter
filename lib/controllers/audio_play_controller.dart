import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:xive/controllers/audio_controller.dart';
import 'package:rxdart/rxdart.dart' as rxdart;
import 'package:flutter/services.dart';
import '../services/audio_service.dart';
import '../widgets/audio/play_detail_header.dart';


class DurationState {
   DurationState( this.progress,  this.buffered,  this.total);
   Duration progress;
   Duration buffered;
   Duration total;
}

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

  //재생 여부
  RxBool isPlay = false.obs;

  //자막 보기 여부
  RxBool isSubtitle = false.obs;

  //재생 오디오 내용
  RxString audioImageUrl = "".obs;
  RxString audioName = "".obs;
  RxString audioArtist = "".obs;
  var audioDescription = [].obs;

  //오디오 설정
  final player = AudioPlayer();
  var speedValue = 1.0.obs;

  var audioProgressSeconds  = 0.obs;
  var subTitleList = [].obs;

  final AutoScrollController scrollController = AutoScrollController();

  Stream<DurationState> get _positionDataStream =>
      rxdart.Rx.combineLatest3<Duration, Duration, Duration?, DurationState>(
          player.positionStream,
          player.bufferedPositionStream,
          player.durationStream,
              (position, bufferedPosition, duration) => DurationState(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      player.stop();
    }
  }


  Future playerState(index) async {

    player.playbackEventStream.listen((event) async{
      if(event.processingState == ProcessingState.completed){
        await player.stop();
        await autoNext();
      }
    }).onError((Object e, StackTrace st){
      print("error");
    });
  }


  Future<void> autoNext() async{
    if(!checkPlayIsEnd()){
      AudioController.to.playIndex.value += 1;
      await updatePlay(AudioController.to.playIndex.value);
    }else{
      isPlay.value = false;
    }

    if(isPlay.value){
      player.play();
    }else{
      player.pause();
    }
  }

  //index가 바뀌었을 때, audio_play_controller 갱신
  Future<void> updatePlay(index) async {

    var audioContents = AudioController.to.playList[index];

    //header
    audioImageUrl.value = audioContents["audioImageUrl"];
    audioName.value = audioContents["audioName"];
    audioArtist.value = "Michel Henry";
    audioDescription.value = ['2011, 캔버스에 아크릴릭, 펜, 국립현대미술관 소장',  '국립현대미술관 발전 후원위원회 기증 '];

    // player url 갱신
    try {
      await player.setUrl(audioContents["audioSoundUrl"]);
    } on PlayerException catch (e) {
      // iOS/macOS: maps to NSError.code
      // Android: maps to ExoPlayerException.type
      // Web: maps to MediaError.code
      // Linux/Windows: maps to PlayerErrorCode.index
      print("Error code: ${e.code}");
      // iOS/macOS: maps to NSError.localizedDescription
      // Android: maps to ExoPlaybackException.getMessage()
      // Web/Linux: a generic message
      // Windows: MediaPlayerError.message
      print("Error message: ${e.message}");
    } on PlayerInterruptedException catch (e) {
      // This call was interrupted since another audio source was loaded or the
      // player was stopped or disposed before this audio source could complete
      // loading.
      print("Connection aborted: ${e.message}");
    } catch (e) {
      // Fallback for all other errors
      print('An error occured: $e');
    }

    playerState(index);
    //오디오 자막 갱신
    await updateSubtitle(audioContents["audioId"]);

  }

  Future<void> updateSubtitle(audioId) async{
    var data = await AudioService().getAudioSubtitle(audioId);

    var audioSubtitleResponse = data["data"];
    subTitleList.clear();

    audioSubtitleResponse.forEach((element){
      subTitleList.value.add({
        "subtitlesId": element["subtitlesId"],
        "sentence": element["sentence"],
        "startTime": element["startTime"]
      });
    });

    update();
  }

  //재생 여부 갱신
  updateIsPlay(){
    isPlay.value = !isPlay.value;
    if(isPlay.value){
      player.play();
    }else{
      player.pause();
    }
  }

  checkPlayIsEnd(){
    return AudioController.to.playIndex.value == AudioController.to.playList.length-1;
  }

  //다음 곡
  nextPlayList() async{
    if(checkPlayIsEnd()){
      endPlayer();
    }
    AudioController.to.playIndex.value += 1;
    await updatePlay(AudioController.to.playIndex.value);

    AudioController.to.update();
    update();
  }

  //이전 곡
  beforePlayList() async{

    if(AudioController.to.playIndex.value != 0){
      AudioController.to.playIndex.value -= 1;
      await updatePlay(AudioController.to.playIndex.value);

      AudioController.to.update();
      update();
    }
  }

  //스피드 변경
  updatePlaySpeed(double value) async{
    speedValue.value = value;
    await player.setSpeed(speedValue.value);
    update();
  }

  //10초 전
  before10Seconds() async{
    player.seek( player.position - Duration(seconds: 10));
    update();
  }

  //10초 뒤
  after10Seconds() async{
    player.seek( player.position + Duration(seconds: 10));
    update();
  }



  // 멈추기
  endPlayer() async{
    isPlay.value = false;
    await player.stop();
    update();
  }

  changeSubtitle(int index){
    player.seek(Duration(seconds: subTitleList[index]["startTime"],));
    update();
  }

  checkIsHighLight(currentSeconds, index){
    if(currentSeconds == null) return false;
    if(currentSeconds>= subTitleList[index]["startTime"] && index == subTitleList.length-1) return true;
    if(currentSeconds>= subTitleList[index]["startTime"] && currentSeconds < subTitleList[index+1]["startTime"]){
      return true;
    }
    return false;
  }


  Widget playUnderBar(BuildContext context){
    return Obx( () => Container(
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 8),
      // color: Colors.white,
      child: Column(
        children: [
          AudioPlayController.to.musicProgressBar(),
          SizedBox(height: 5,),
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
                        borderRadius: BorderRadius.circular(5.0),
                        child: AudioPlayController.to.audioImageUrl != "" ?
                        Image.network(AudioPlayController.to.audioImageUrl.value,height: 32, width: 32, fit: BoxFit.fill,):
                        SizedBox(
                          width: 32,
                          height: 32,
                          child: Stack(
                              children:[
                                Container(
                                  height: 32,
                                  width: 32,
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
                        child: Text(
                          '${AudioPlayController.to.audioName}',
                          style: TextStyle(color: Get.isDarkMode? Color(0xFFDFDFDF):Colors.black, fontSize: 16, fontFamily: 'Pretendard', fontWeight: FontWeight.w400,letterSpacing: -0.32,),
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
                      child: SvgPicture.asset(Get.isDarkMode?"assets/images/Stop_and_play_left_dark.svg":"assets/images/Stop_and_play_left_light.svg", width: 32, height: 32, fit: BoxFit.fitHeight,),
                    ),
                    InkWell(
                      onTap: (){
                        updateIsPlay();
                      },
                      child: AudioPlayController.to.isPlay.value ? SvgPicture.asset(Get.isDarkMode?"assets/images/Stop_dark.svg":"assets/images/Stop_light.svg", width: 32, height: 32, fit: BoxFit.fitHeight)
                          :SvgPicture.asset(Get.isDarkMode?"assets/images/play_dark.svg":"assets/images/play_light.svg", width: 32, height: 32, fit: BoxFit.fitHeight,),
                    ),
                    InkWell(
                      onTap: () {
                        nextPlayList();
                      },
                      child: SvgPicture.asset(Get.isDarkMode?"assets/images/Stop_and_play_right_dark.svg":"assets/images/Stop_and_play_right_light.svg", width: 32, height: 32,fit: BoxFit.fitHeight),
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
                    before10Seconds();
                  }, child: SvgPicture.asset(Get.isDarkMode?"assets/images/10_seconds_before_dark.svg":"assets/images/10_seconds_before_light.svg", width: 32, height: 32, fit: BoxFit.fitHeight,)
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () async{
                        beforePlayList();
                      }, child: SvgPicture.asset(Get.isDarkMode?"assets/images/Stop_and_play_left_dark.svg":"assets/images/Stop_and_play_left_light.svg", width: 32, height: 32, fit: BoxFit.fitHeight,)
                    ),
                    SizedBox(width: 5,),
                    Obx(() => InkWell(
                          onTap: (){
                            updateIsPlay();
                          },child: isPlay.value? SvgPicture.asset(Get.isDarkMode?"assets/images/Stop_dark.svg":"assets/images/Stop_light.svg", width: 54, height: 54, fit: BoxFit.fitHeight,)
                        :SvgPicture.asset(Get.isDarkMode?"assets/images/play_dark.svg":"assets/images/play_light.svg", width: 54, height: 54, fit: BoxFit.fitHeight,)
                      ),
                    ),
                    SizedBox(width: 5,),
                    InkWell(onTap:() {
                      nextPlayList();
                    },child: SvgPicture.asset(Get.isDarkMode?"assets/images/Stop_and_play_right_dark.svg":"assets/images/Stop_and_play_right_light.svg", width: 32, height: 32, fit: BoxFit.fitHeight,)
                    )
                  ],
                ),

                InkWell(
                    onTap: () {
                      after10Seconds();
                    },child: SvgPicture.asset(Get.isDarkMode?"assets/images/10_seconds_after_dark.svg":"assets/images/10_seconds_after_light.svg", width: 32, height: 32, fit: BoxFit.fitHeight,)
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
                                    color: Get.isDarkMode?Color(0xFF222222):Color(0xFFF9F9F9),
                                    borderRadius: BorderRadius.circular(4)
                                ),
                                child: SfSliderTheme(
                                  data: SfSliderThemeData(
                                    activeTrackHeight:1.5,
                                    inactiveTrackHeight : 1.5,
                                    thumbRadius:7,
                                    labelOffset: Offset(0.0, 8),
                                    activeLabelStyle: TextStyle(color: Get.isDarkMode? Colors.white:Colors.black, fontSize: 10, fontFamily: 'Pretendard', fontWeight: FontWeight.w500, letterSpacing: -0.20,),
                                    inactiveLabelStyle: TextStyle(color:Get.isDarkMode? Colors.white:Colors.black, fontSize: 10, fontFamily: 'Pretendard', fontWeight: FontWeight.w500, letterSpacing: -0.20,),
                                  ),
                                  child: SfSlider(
                                      min: 0.5,
                                      max: 1.5,
                                      value: speedValue.value,
                                      showLabels: true,
                                      enableTooltip: false,
                                      interval: 0.25,
                                      stepSize: 0.25,
                                      activeColor: Get.isDarkMode?Colors.white:Colors.black,
                                      inactiveColor: Get.isDarkMode?Colors.white24.withOpacity(0.5):Color(0x9E9E9E).withOpacity(0.5),
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
                        SvgPicture.asset(Get.isDarkMode?"assets/images/Speed_alt_dark.svg":"assets/images/Speed_alt_light.svg", width: 24, height: 24, fit: BoxFit.fitHeight,),
                        const SizedBox(width: 5,),
                        Obx(() => Text(
                            '재생 속도 (x${speedValue.value})',
                            style: TextStyle(color: Get.isDarkMode?Colors.white:Colors.black, fontSize: 10, fontWeight: FontWeight.w500),
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
                        SvgPicture.asset(Get.isDarkMode?"assets/images/cc_dark.svg":"assets/images/cc_light.svg", width: 24, height: 24, fit: BoxFit.fitHeight,),
                        const SizedBox(width: 5,),
                        Text(
                          '자막 보기',
                          style: TextStyle(color:Get.isDarkMode?Colors.white:Colors.black, fontSize: 10, fontWeight: FontWeight.w500 ),
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
            //TODO opacity 80 -> 90
            color: Get.isDarkMode?Colors.black.withOpacity(0.9):Colors.white.withOpacity(0.9),
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
                                    child: PlayDetailHeader()
                                ),
                                Obx(()=>Expanded(
                                    child: isSubtitle.value == false?
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(audioImageUrl.value, width: double.infinity, fit: BoxFit.fitWidth,),
                                    ): ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: subTitleList.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return StreamBuilder(
                                        stream: _positionDataStream,
                                        builder: (context, snapshot) {
                                          var highLightIndex = false.obs;
                                          if(snapshot.hasData){
                                            highLightIndex.value = checkIsHighLight(snapshot.data!.progress.inSeconds,index);
                                          }
                                          return InkWell(
                                            onTap: (){
                                              changeSubtitle(index);
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.fromLTRB(0,0,0,26),
                                              child: Text(
                                                  subTitleList[index]["sentence"],
                                                  style:  highLightIndex.value ? TextStyle(color: Get.isDarkMode?Colors.white:Colors.black, fontSize: 20, fontFamily: 'Pretendard', fontWeight: FontWeight.w700, letterSpacing: -0.40,)
                                                      :TextStyle(color: Get.isDarkMode?Colors.white.withOpacity(0.5):Colors.black.withOpacity(0.5), fontSize: 20, fontFamily: 'Pretendard', fontWeight: FontWeight.w700, letterSpacing: -0.40,),
                                              ),
                                            ),
                                          );}
                                        );
                                      },
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

  musicProgressBar(){
    return StreamBuilder(
      stream: _positionDataStream,
        builder: (context, snapshot) {
          return  ProgressBar(
            progress: snapshot.data?.progress ?? Duration.zero ,
            buffered: snapshot.data?.buffered ?? Duration.zero,
            total: snapshot.data?.total ?? Duration.zero,
            progressBarColor: Get.isDarkMode?Colors.white:Colors.black,
            baseBarColor: Get.isDarkMode?Colors.white.withOpacity(0.24):Color(0xFF9E9E9E),
            bufferedBarColor: Get.isDarkMode?Colors.white.withOpacity(0.24):Color(0xFF9E9E9E),
            thumbColor: Get.isDarkMode?Colors.white:Colors.black,
            barHeight: 3.0,
            thumbRadius: 0.0,
            onSeek: (duration) => player.seek(duration)
          );
        },

    );
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    update();
  }



  @override
  void dispose() {
    // TODO: implement dispose
    player.dispose();
    super.dispose();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    player.dispose();
    super.onClose();
  }
}
