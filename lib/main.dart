import 'package:coderem/Widgets/interval_timer.dart';
import 'package:coderem/local_notifications.dart';
import 'package:coderem/pages/alarm_page.dart';
import 'package:coderem/pages/home_page.dart';
import 'package:coderem/pages/login_page.dart';
import 'package:coderem/ApiCalls/all_contests_req.dart';
import 'package:coderem/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == "fetch_alarm_data") {
      List<Contest> contests = await fetchContests();
      if (contests.isEmpty) {
        return Future.value(false);
      }
      contests.sort((a, b) => b.startTimeSeconds.compareTo(a.startTimeSeconds));
      Contest upcoming = contests[0];
      String time = getTimeUntilStart(upcoming.startTimeSeconds);
      LocalNotifications.showNotification(
        title: upcoming.name,
        body: '$time until the contest starts',
        payload: "https://codeforces.com/contests",
      );
      LocalNotifications.scheduledNotification(
        id: 2,
        title: "⚠️ Contest Will Start in 10 Minutes",
        body: upcoming.name,
        payload: "https://codeforces.com/contests",
        startTimeSecond: upcoming.startTimeSeconds - 10 * 60,
      );

      saveContestsOnSharedPreference(contests: contests);
      print("Alarm Data fetched $task");
    }
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalNotifications.init();

  Workmanager().initialize(
    callbackDispatcher, // The top level function, aka callbackDispatcher
    isInDebugMode:
        !kReleaseMode, // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
  );
  // Register periodic task every 12 hours
  Workmanager().registerPeriodicTask(
    "fetch_alarm_task",
    "fetch_alarm_data",
    frequency: Duration(hours: 12),
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xffde9d96),
            surface: Color.fromARGB(255, 252, 244, 240)),
        fontFamily: "Quicksand",
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
