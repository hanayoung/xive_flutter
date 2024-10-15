
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
      response = {
        "eventPlace": "국립현대 미술관 제 1전시장",
        "eventName": "위대한 컬러리스 <<미셀 앙리>>",
        "eventBackgroundImageUrl": "https://xive-static-files.s3.ap-northeast-2.amazonaws.com/event_background_image/6",
        "audioCount": 14,
        "runningTime": 20,
        "audioCoreResponse": [
          {
            "audioImageUrl": "https://xive-static-files.s3.ap-northeast-2.amazonaws.com/event_background_image/6",
            "audioSoundUrl": "audioSoundUrl2",
            "audioName": "붉은 꽃 그림1"
          },
          {
            "audioImageUrl": "https://xive-static-files.s3.ap-northeast-2.amazonaws.com/event_background_image/6",
            "audioSoundUrl": "audioSoundUrl2",
            "audioName": "붉은 꽃 그림2"
          },
          {
            "audioImageUrl": "https://xive-static-files.s3.ap-northeast-2.amazonaws.com/event_background_image/6",
            "audioSoundUrl": "audioSoundUrl3",
            "audioName": "붉은 꽃 그림3"
          },
          {
            "audioImageUrl": "https://xive-static-files.s3.ap-northeast-2.amazonaws.com/event_background_image/6",
            "audioSoundUrl": "audioSoundUrl4",
            "audioName": "붉은 꽃 그림4"
          },
          {
            "audioImageUrl": "https://xive-static-files.s3.ap-northeast-2.amazonaws.com/event_background_image/6",
            "audioSoundUrl": "audioSoundUrl5",
            "audioName": "붉은 꽃 그림5"
          },
          {
            "audioImageUrl": "https://xive-static-files.s3.ap-northeast-2.amazonaws.com/event_background_image/6",
            "audioSoundUrl": "audioSoundUrl6",
            "audioName": "붉은 꽃 그림6"
          },
          {
            "audioImageUrl": "https://xive-static-files.s3.ap-northeast-2.amazonaws.com/event_background_image/6",
            "audioSoundUrl": "audioSoundUrl7",
            "audioName": "붉은 꽃 그림7"
          },
          {
            "audioImageUrl": "https://xive-static-files.s3.ap-northeast-2.amazonaws.com/event_background_image/6",
            "audioSoundUrl": "audioSoundUrl8",
            "audioName": "붉은 꽃 그림8"
          },
          {
            "audioImageUrl": "https://xive-static-files.s3.ap-northeast-2.amazonaws.com/event_background_image/6",
            "audioSoundUrl": "audioSoundUrl9",
            "audioName": "붉은 꽃 그림9"
          }
        ]
      };

      return response;
    }
    throw Error();

  }


}