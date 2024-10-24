import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xive/controllers/ticket_controller.dart';
import 'package:xive/main.dart';
import 'package:xive/models/ticket_model.dart';
import 'package:xive/routes/pages.dart';

class HomeTicket extends StatelessWidget {
  final TicketController controller = TicketController.to;
  HomeTicket({super.key});
  onTicketClicked(BuildContext context, TicketModel ticket) {
    if (ticket.audioExist == true) {
      print("ticket ? ${ticket.ticketId}");
      Get.toNamed(Routes.guide, arguments: ticket);
    } else {
      Get.toNamed(Routes.webview, arguments: ticket);
    }
  }

  @override
  Widget build(BuildContext context) {
    controller.buildContext = context;

    return LayoutBuilder(
      builder: (context, constraints) {
        double cardWidth = constraints.maxWidth * 1.0;
        double aspectRatio = 7 / 9;
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            SizedBox(
              width: cardWidth,
              child: AspectRatio(
                  aspectRatio: aspectRatio,
                  child: Obx(() {
                    return Swiper(
                      loop: false,
                      itemCount: controller.ticketList.length,
                      viewportFraction: 0.8,
                      scale: 0.9,
                      pagination: SwiperPagination(
                        alignment: const Alignment(0.0, 1.2),
                        builder: DotSwiperPaginationBuilder(
                          activeSize: 10.0,
                          space: 5.0,
                          activeColor: lightModeTheme.primaryColor,
                          color: lightModeTheme.disabledColor,
                        ),
                      ),
                      onIndexChanged: (value) {
                        controller.setBgImg(value);
                      },
                      itemBuilder: (context, index) {
                        final ticket = controller.ticketList[index];
                        return Card(
                          color: Colors.transparent,
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
                    );
                  })),
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
