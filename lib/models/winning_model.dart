class WinningModel {
  final bool isWinningCalendar, isWinningPostcard;

  WinningModel({
    required this.isWinningCalendar,
    required this.isWinningPostcard,
  });

  WinningModel.fromJson(Map<String, dynamic> json)
      : isWinningCalendar = json['isWinningCalendar'],
        isWinningPostcard = json['isWinningPostcard'];
}
