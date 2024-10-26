import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:xive/models/ticket_list_model.dart';
import 'package:xive/models/ticket_model.dart';
import 'package:xive/services/dio_interceptor.dart';

class TicketService {
  final dio = Dio();
  final baseUrl = dotenv.env['BASE_URL'];
  final dioInterceptor = DioInterceptor();
  TicketService._privateConstructor();

  static final TicketService _instance = TicketService._privateConstructor();

  factory TicketService() {
    return _instance;
  }
  Future<List<TicketModel>> getAllTickets(
      String accessToken, String refreshToken) async {
    dio.interceptors.clear();
    dio.interceptors.add(dioInterceptor);

    final response = await dio.get("$baseUrl/tickets");

    if (response.statusCode == 200) {
      TicketListModel data = TicketListModel.fromJson(response.data);

      return data.ticketList;
    }
    throw Error();
    // todo 에러 처리 추가해서 에러 화면으로 이동해야함
  }

  Future<TicketModel> getOneTicket(
      String accessToken, String refreshToken) async {
    TicketModel ticketInstance;

    final response = await dio.get("$baseUrl/tickets",
        options: Options(headers: {
          "AccessToken": accessToken,
          "RefreshToken": refreshToken,
        }));
    if (response.statusCode == 200) {
      ticketInstance = TicketModel.fromJson(response.data);
      return ticketInstance;
    }
    throw Error();
    // todo 에러 처리 추가해서 에러 화면으로 이동해야함
  }

  Future<TicketModel> postTicket(
      String accessToken, String refreshToken, int eventId) async {
    TicketModel ticketInstance;
    dio.interceptors.clear();
    dio.interceptors.add(dioInterceptor);
    final response = await dio.post("$baseUrl/exhibition-tickets", data: {
      "eventId": eventId,
    });
    if (response.statusCode == 200) {
      ticketInstance = TicketModel.fromJson(response.data);
      return ticketInstance;
    }
    throw Error();
    // todo 에러 처리 추가해서 에러 화면으로 이동해야함
  }

  Future<bool> getWinningStatus(int ticketId) async {
    dio.interceptors.clear();
    dio.interceptors.add(dioInterceptor);
    final response = await dio.get("$baseUrl/tickets/$ticketId/winning-status");
    print("response ${response.data}");
    if (response.statusCode == 200) {
      return (response.data)['isWinning'];
    }
    throw Error();
  }
}
