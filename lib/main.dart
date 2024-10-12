import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:provider/provider.dart';
import 'package:xive/providers/schedule_provider.dart';
import 'package:xive/providers/ticket_provider.dart';
import 'package:xive/screens/home_screen.dart';
import 'package:xive/screens/on_boarding_screen.dart';
import 'package:xive/screens/setting_screen.dart';
import 'package:xive/screens/signup_screen.dart';

import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  KakaoSdk.init(
    nativeAppKey: dotenv.env['NATIVE_API_KEY'],
  );
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => TicketProvider(),
      ),
      ChangeNotifierProvider(
        create: (context) => ScheduleProvider(),
      ),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TicketProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ScheduleProvider(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: "Pretendard",
          colorScheme: const ColorScheme.light(
            surface: Colors.black,
          ),
          primaryColor: const Color(0xff8000FF),
          disabledColor: const Color(0xFFD9D9D9),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(
              color: Colors.black,
              fontSize: 16,
              letterSpacing: -0.02,
            ),
            bodySmall: TextStyle(
              color: Color(0xFF191919),
              fontSize: 14,
              letterSpacing: -0.02,
            ),
            titleMedium: TextStyle(
              color: Colors.black,
              fontSize: 24,
              letterSpacing: -0.02,
              fontWeight: FontWeight.w700,
            ),
          ),
          dividerColor: const Color(0xFFF4F4F4),
        ),
        initialRoute: '/',
        routes: {
          '/onboarding': (context) => const OnBoardingScreen(),
          '/': (context) => const SplashScreen(),
          '/signup': (context) => const SignupScreen(),
          '/home': (context) => const HomeScreen(),
          '/setting': (context) => SettingScreen(),
        },
      ),
    );
  }
}
