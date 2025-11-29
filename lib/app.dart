import 'package:flutter/material.dart';
import 'pages/dashboard_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFEBFFF5),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF579C79),
          foregroundColor: Color(0xFFFFFFFF),
          elevation: 0,
        ),
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFFFFFFF),
            )
        ),
      ),
      home: DashboardPage(),
    );

  }
}