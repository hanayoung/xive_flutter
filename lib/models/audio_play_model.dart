class AudioPlayModel {
  final int audioId;
  final String audioImageUrl, audioSoundUrl, audioName;

  AudioPlayModel.fromJson(Map<String, dynamic> json)
      : audioId = json['audioId'],
        audioImageUrl = json['audioImageUrl'],
        audioSoundUrl = json['audioSoundUrl'],
        audioName = json['audioName'];
}
