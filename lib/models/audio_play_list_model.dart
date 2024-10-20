import 'package:xive/models/audio_play_model.dart';

class AudioPlayListModel {
  final List<AudioPlayModel> audioPlayList;

  AudioPlayListModel.fromJson(Map<String, dynamic> json)
      : audioPlayList = (json['audioCoreResponse'] as List)
      .map((item) => AudioPlayModel.fromJson(item))
      .toList();
}
