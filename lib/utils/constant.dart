import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  Constants._privateConstructor();

  static final Constants _instance = Constants._privateConstructor();

  factory Constants() {
    return _instance;
  }

  static final Map<String, dynamic> _config = _Config.constants;


  static get baseUrl {
    return _config[_Config.baseUrl];
  }

  static get apiEventUrl {
    return _config[_Config.baseUrl] + _config[_Config.eventUrl];
  }

  static get apiAudioUrl {
    return _config[_Config.baseUrl] + _config[_Config.audioUrl];
  }


}

class _Config {
  static const baseUrl = "baseUrl";

  static const eventUrl = "eventUrl";
  static const audioUrl = "audioUrl";



  static Map<String, dynamic> constants = {
    baseUrl: dotenv.env["BASE_URL"],

    eventUrl: "/event",
    audioUrl: "/audio",

  };
}