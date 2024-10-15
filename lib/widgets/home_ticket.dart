import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xive/controllers/ticket_controller.dart';
import 'package:xive/models/ticket_model.dart';
import 'package:xive/routes/pages.dart';

class HomeTicket extends StatelessWidget {
  final List<TicketModel> ticketList;
  HomeTicket({super.key, required this.ticketList});
  final TicketController controller = TicketController.to;
  onTicketClicked(BuildContext context, TicketModel ticket) {
    Get.toNamed(Routes.webview, arguments: ticket);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double cardWidth = constraints.maxWidth * 1.0;
        double aspectRatio = 7 / 9;
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 1),
            SizedBox(
              width: cardWidth,
              child: AspectRatio(
                aspectRatio: aspectRatio,
                child: Swiper(
                  loop: false,
                  itemCount: ticketList.length,
                  viewportFraction: 0.8,
                  scale: 0.9,
                  pagination: SwiperPagination(
                    alignment: const Alignment(0.0, 1.2),
                    builder: DotSwiperPaginationBuilder(
                      activeSize: 10.0,
                      space: 5.0,
                      activeColor: Theme.of(context).primaryColor,
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                  onIndexChanged: (value) {
                    controller.setBgImg(value);
                  },
                  itemBuilder: (context, index) {
                    final ticket = ticketList[index];
                    return Card(
                      clipBehavior: Clip.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(36.0),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(36.0),
                        onTap: () => onTicketClicked(context, ticket),
                        child: Column(
                          children: [
                            Expanded(
                              child: Image.network(
                                ticket.eventImageUrl!,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const Spacer(
              flex: 2,
            )
          ],
        );
      },
    );
  }
}
