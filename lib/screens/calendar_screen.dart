import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:xive/widgets/title_bar.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime? selectedDay;
    List<String> days = ['_', '월', '화', '수', '목', '금', '토', '일'];
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          const TitleBar(title: "캘린더"),
          TableCalendar(
            locale: 'ko_KR',
            firstDay: DateTime(2024, 1, 1),
            lastDay: DateTime(now.year, now.month + 1, 0),
            focusedDay: now,
            calendarFormat: CalendarFormat.month,
            headerStyle: HeaderStyle(
              titleCentered: false,
              titleTextStyle: const TextStyle(
                color: Colors.black,
                fontSize: 24,
                letterSpacing: -0.02,
                fontWeight: FontWeight.w700,
              ),
              formatButtonVisible: false,
              leftChevronVisible: false,
              titleTextFormatter: (date, locale) =>
                  DateFormat.yMMMM(locale).format(date),
            ),
            daysOfWeekHeight: 24,
            rowHeight: 78,
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              // rowDecoration: const BoxDecoration(
              //   image: DecorationImage(
              //     image: AssetImage(
              //       'assets/images/splash_logo.gif',
              //     ),
              //   ),
              // ),
            ),

            //     image: DecorationImage(
            //         image: NetworkImage(
            //   "https://www.google.com/imgres?q=%ED%94%BC%EC%B9%B4%EC%B8%84&imgurl=https%3A%2F%2Fi2.ruliweb.com%2Fimg%2F22%2F05%2F24%2F180f257d1e348138f.png&imgrefurl=https%3A%2F%2Fbbs.ruliweb.com%2Fcommunity%2Fboard%2F300143%2Fread%2F57263285&docid=ysYegqFgH4hrrM&tbnid=shUdlfrVIch1nM&vet=12ahUKEwj4jbyB4ZiJAxUVZfUHHU9QJRwQM3oECFcQAA..i&w=800&h=787&hcb=2&ved=2ahUKEwj4jbyB4ZiJAxUVZfUHHU9QJRwQM3oECFcQAA",
            // ))

            onDaySelected: (selectedDay, focusedDay) {
              selectedDay = selectedDay;
              now = focusedDay;
            },
            pageJumpingEnabled: true,
            // selectedDayPredicate: (day) {
            //   return isSameDay(selectedDay, day);
            // },

            calendarBuilders: CalendarBuilders(
              // dowBuilder: (context, day) {
              //   return Center(
              //       child: Text(
              //     days[day.weekday],
              //     style: const TextStyle(
              //       color: Color(0xFF9E9E9E),
              //       fontSize: 16,
              //       letterSpacing: -0.02,
              //     ),
              //   ));
              // },
              defaultBuilder: (context, day, focusedDay) {
                return Center(
                  child: Image.asset(
                    'assets/images/splash_logo.gif',
                  ),
                );
              },
              // markerBuilder: (context, day, events) {

              // },
            ),
          )
        ],
      )),
    );
  }
}
