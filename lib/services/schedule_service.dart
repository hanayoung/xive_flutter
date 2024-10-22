import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:xive/models/schedule_list_model.dart';
import 'package:xive/models/schedule_model.dart';

class ScheduleService {
  final baseUrl = dotenv.env['BASE_URL'];
  final dio = Dio();

  Future<List<ScheduleModel>> getScheduleList(
      String yearMonth, String accessToken, String refreshToken) async {
    // List<ScheduleModel> scheduleInstances;

    final response = await dio.get("$baseUrl/schedules",
        options: Options(headers: {
          "AccessToken": accessToken,
          "RefreshToken": refreshToken,
        }),
        queryParameters: {
          "yearMonth": yearMonth,
        });
    if (response.statusCode == 200) {
      ScheduleListModel data = ScheduleListModel.fromJson(response.data);
      print("scheduleList $data");
      return data.scheduleList;
    }
    throw Error();
    // todo 에러 처리 추가해서 에러 화면으로 이동해야함
  }
}
