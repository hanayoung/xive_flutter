import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:xive/routes/pages.dart';

final lightModeTheme = ThemeData(
  fontFamily: "Pretendard",
  colorScheme: const ColorScheme.light(
    surface: Colors.white,
  ),
  primaryColor: const Color(0xff8000FF),
  disabledColor: const Color(0xFFD9D9D9),
  textTheme: const TextTheme(
    labelSmall: TextStyle(
      color: Color(0xFF9E9E9E),
      letterSpacing: -0.02,
      fontSize: 14,
    ),
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
    titleSmall: TextStyle(
      color: Colors.black,
      fontSize: 16,
      letterSpacing: -0.02,
      fontWeight: FontWeight.w600,
    ),
  ),
  dividerColor: const Color(0xFFF4F4F4),
);

final darkModeTheme = ThemeData(
  fontFamily: "Pretendard",
  colorScheme: const ColorScheme.light(
    surface: Colors.white,
  ),
  primaryColor: const Color(0xff8000FF),
  disabledColor: const Color(0xFFD9D9D9),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(
      color: Colors.white,
      fontSize: 16,
      letterSpacing: -0.02,
    ),
    bodySmall: TextStyle(
      color: Color(0xFF191919),
      fontSize: 14,
      letterSpacing: -0.02,
    ),
    titleMedium: TextStyle(
      color: Colors.white,
      fontSize: 24,
      letterSpacing: -0.02,
      fontWeight: FontWeight.w700,
    ),
    titleSmall: TextStyle(
      color: Colors.white,
      fontSize: 16,
      letterSpacing: -0.02,
      fontWeight: FontWeight.w600,
    ),
  ),
  dividerColor: const Color(0xFFF4F4F4),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  KakaoSdk.init(
    nativeAppKey: dotenv.env['NATIVE_API_KEY'],
  );
  initializeDateFormatting().then((_) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'XIVE',
      locale: const Locale('ko'),
      getPages: Pages.pages,
      theme: lightModeTheme,
      darkTheme: darkModeTheme,
      themeMode: ThemeMode.light,
    );
  }
}
