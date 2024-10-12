import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xive/models/ticket_model.dart';
import 'package:xive/providers/ticket_provider.dart';
import 'package:xive/screens/webview_screen.dart';

class HomeTicket extends StatelessWidget {
  final List<TicketModel> ticketList;
  const HomeTicket({super.key, required this.ticketList});

  onTicketClicked(BuildContext context, TicketModel ticket) {
    print("ticket clicked");

    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return WebviewScreen(
          webUrl: ticket.eventWebUrl!,
          eventId: ticket.eventId,
          ticketId: ticket.ticketId,
          isNewVisited: ticket.isNew);
    }));
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
                    // context.read<TicketProvider>().setBgImg(value);
                  },
                  itemBuilder: (context, index) {
                    final ticket = ticketList[index];
                    return Card(
                      clipBehavior: Clip.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20.0),
                        onTap: () => onTicketClicked(context, ticket),
                        child: Column(
                          children: [
                            Expanded(
                              child: Image.network(
                                ticket.eventImageUrl!,
                                fit: BoxFit.cover,
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
