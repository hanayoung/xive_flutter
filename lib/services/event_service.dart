import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:xive/models/event_model.dart';

class EventService {
  final baseUrl = dotenv.env['BASE_URL'];
  final dio = Dio();

  Future<EventModel> getEventData(
      String accessToken, String refreshToken, String eventToken) async {
    EventModel eventInstance;

    final response = await dio.get("$baseUrl/event/tagging",
        options: Options(headers: {
          "AccessToken": accessToken,
          "RefreshToken": refreshToken,
        }),
        queryParameters: {
          "eventToken": eventToken,
        });
    if (response.statusCode == 200) {
      eventInstance = EventModel.fromJson(response.data);
      print("eventInstance $eventInstance");
      return eventInstance;
    }
    throw Error();
    // todo 에러 처리 추가해서 에러 화면으로 이동해야함
  }
}
