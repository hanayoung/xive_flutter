import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:xive/models/event_model.dart';
import 'package:xive/services/dio_interceptor.dart';

class EventService {
  final baseUrl = dotenv.env['BASE_URL'];
  final dio = Dio();
  final dioInterceptor = DioInterceptor();
  EventService._privateConstructor();

  static final EventService _instance = EventService._privateConstructor();

  factory EventService() {
    return _instance;
  }
  Future<EventModel> getEventData(
      String accessToken, String refreshToken, String eventToken) async {
    EventModel eventInstance;
    dio.interceptors.clear();
    dio.interceptors.add(dioInterceptor);
    final response = await dio.get("$baseUrl/event/tagging", queryParameters: {
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
