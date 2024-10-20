import 'package:xive/models/audio_play_list_model.dart';

class AudioModel {
  final String eventPlace, eventName, eventBackgroundImageUrl;
  final int audioCount, runningTime;
  final AudioPlayListModel audioCoreResponse;

  AudioModel(String eventPlace, String eventName, String eventBackgroundImageUrl, int audioCount, int runningTime,AudioPlayListModel audioCoreResponse)
  :this.eventPlace = eventPlace,
  this.eventName = eventName,
  this.eventBackgroundImageUrl = eventBackgroundImageUrl,
  this.audioCount = audioCount,
  this.runningTime = runningTime,
  this.audioCoreResponse = audioCoreResponse;

  AudioModel.fromJson(Map<String, dynamic> json)
      : eventPlace = json['eventPlace'],
        eventName = json['eventName'],
        eventBackgroundImageUrl = json['eventBackgroundImageUrl'],
        audioCount = json['audioCount'],
        runningTime = json['runningTime'],
        audioCoreResponse = AudioPlayListModel.fromJson(json);
}
