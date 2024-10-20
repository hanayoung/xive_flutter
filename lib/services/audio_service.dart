
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:xive/models/audio_model.dart';

import '../utils/constant.dart';
import 'dio_interceptor.dart';

class AudioService{

  final dio = Dio();
  final dioInterceptor = DioInterceptor();

  AudioService._privateConstructor();

  static final AudioService _instance = AudioService._privateConstructor();

  factory AudioService() {
    return _instance;
  }

  getEventAudio(int eventId) async{
    var response;
    dio.interceptors.clear();
    dio.interceptors.add(dioInterceptor);

    String url = Constants.apiEventUrl+'/audio'+'/${eventId}';
    response = await dio.get(url);

    if (response.statusCode == 200) {
      return response.data;
    }
    throw Error();

  }

  getAudioSubtitle(int audioId) async{
    var response;
    dio.interceptors.clear();
    dio.interceptors.add(dioInterceptor);

    String url = Constants.apiAudioUrl+'/subtitles'+'/${audioId}';

    response = await dio.get(url);

    if (response.statusCode == 200) {
      // response = {

      return response.data;
    }
    throw Error();

  }


}