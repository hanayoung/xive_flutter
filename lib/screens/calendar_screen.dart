import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:xive/controllers/splash_controller.dart';
import 'package:xive/main.dart';
import 'package:xive/models/schedule_model.dart';
import 'package:xive/services/schedule_service.dart';
import 'package:xive/widgets/title_bar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  final DateTime _now = DateTime.now();
  late PageController _pageController;
  late List<ScheduleModel> list;
  final SplashController controller = SplashController.to;

  Future<List<ScheduleModel>> getScheduleList() async {
    return ScheduleService().getScheduleList("2024-09",
        controller.accessToken.value!, controller.refreshToken.value!);
  }

  @override
  void initState() {
    getScheduleList().then((value) {
      list = value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map<DateTime, List<dynamic>> events = {
      DateTime.utc(2024, 10, 20): ['Event 1'],
      DateTime.utc(2024, 10, 25): ['Event 2'],
    };
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          const TitleBar(title: "캘린더"),
          _buildCustomHeader(),
          TableCalendar(
            locale: 'ko_KR',
            firstDay: DateTime(2024, 1, 1),
            lastDay: DateTime(_now.year, _now.month + 1, 0),
            focusedDay: _focusedDay,
            calendarFormat: CalendarFormat.month,
            headerVisible: false,
            // headerStyle: HeaderStyle(
            //   titleCentered: false,
            //   titleTextStyle: const TextStyle(
            //     color: Colors.black,
            //     fontSize: 24,
            //     letterSpacing: -0.02,
            //     fontWeight: FontWeight.w700,
            //   ),
            //   formatButtonVisible: false,
            //   leftChevronVisible: false,
            //   titleTextFormatter: (date, locale) =>
            //       DateFormat.yMMMM(locale).format(date),
            // ),
            daysOfWeekHeight: 24,
            rowHeight: 78,
            // rangeSelectionMode: RangeSelectionMode.disabled,
            startingDayOfWeek: StartingDayOfWeek.monday,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: lightModeTheme.primaryColor,
                shape: BoxShape.circle,
              ),
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            pageJumpingEnabled: true,
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                if (events.containsKey(day)) {
                  return Center(
                    child: Image.asset(
                      'assets/images/splash_logo.gif',
                    ),
                  );
                } else {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  );
                }
              },
              dowBuilder: (context, day) {
                final text = DateFormat('E', 'ko').format(day);
                return Center(
                  child: Text(
                    text,
                    style: TextStyle(
                        color: day.weekday == _selectedDay.weekday
                            ? lightModeTheme.primaryColor
                            : Colors.black),
                  ),
                );
              },
            ),
          )
        ],
      )),
    );
  }

  Widget _buildCustomHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${_focusedDay.year}년 ${_focusedDay.month}월',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 24,
              letterSpacing: -0.02,
              fontWeight: FontWeight.w700,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: _previousMonth,
              ),
              _focusedDay.isBefore(DateTime(_now.year, _now.month, 0))
                  ? IconButton(
                      icon: SvgPicture.asset(
                          'assets/images/calendar_right_arrow_on.svg'),
                      onPressed: _nextMonth,
                    )
                  : IconButton(
                      icon: SvgPicture.asset(
                          'assets/images/calendar_right_arrow_off.svg'),
                      onPressed: null,
                    ),
            ],
          )
        ],
      ),
    );
  }

  void _previousMonth() {
    setState(() {
      _focusedDay = DateTime(
        _focusedDay.year,
        _focusedDay.month - 1,
        _focusedDay.day,
      );
    });

    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _nextMonth() {
    setState(() {
      _focusedDay = DateTime(
        _focusedDay.year,
        _focusedDay.month + 1,
        _focusedDay.day,
      );
    });

    // TableCalendar의 페이지 이동
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // PageController를 Calendar에 할당하여 이전/다음 달 이동 처리
    _pageController = PageController(initialPage: _focusedDay.month - 1);
  }
}
