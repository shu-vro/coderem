import 'package:coderem/pages/alarm_page.dart';
import 'package:coderem/pages/home_page.dart';
import 'package:coderem/pages/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xffde9d96),
            surface: Color.fromARGB(255, 252, 244, 240)),
        fontFamily: "KumbhSans",
        useMaterial3: true,
      ),
      home: const HomePage(),
      routes: {
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/alarm': (context) => const AlarmPage(),
      },
    );
  }
}
