import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:xive/models/ticket_list_model.dart';
import 'package:xive/models/ticket_model.dart';

class TicketService {
  final baseUrl = dotenv.env['BASE_URL'];
  final dio = Dio();

  Future<List<TicketModel>> getAllTickets(
      String accessToken, String refreshToken) async {
    List<TicketModel> ticketInstances;

    final response = await dio.get("$baseUrl/tickets",
        options: Options(headers: {
          "AccessToken": accessToken,
          "RefreshToken": refreshToken,
        }));
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
    final response = await dio.post("$baseUrl/exhibition-tickets",
        options: Options(headers: {
          "AccessToken": accessToken,
          "RefreshToken": refreshToken,
        }),
        data: {
          "eventId": eventId,
        });
    if (response.statusCode == 200) {
      ticketInstance = TicketModel.fromJson(response.data);
      return ticketInstance;
    }
    throw Error();
    // todo 에러 처리 추가해서 에러 화면으로 이동해야함
  }
}
