import 'package:xive/models/schedule_model.dart';

class ScheduleListModel {
  final List<ScheduleModel> scheduleList;

  ScheduleListModel.fromJson(Map<String, dynamic> json)
      : scheduleList = (json['data'] as List)
            .map((item) => ScheduleModel.fromJson(item))
            .toList();
}
