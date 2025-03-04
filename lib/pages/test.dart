import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            print("Button clicked");
            await Workmanager().registerOneOffTask(
              "fetch_alarm_task",
              "fetch_alarm_data",
              // frequency: Duration(seconds: 10),
              initialDelay: Duration(seconds: 10),
              // constraints: Constraints(
              //   networkType: NetworkType.connected,
              // ),
            );
            // await Workmanager().registerPeriodicTask(
            //   "fetch_alarm_task",
            //   "fetch_alarm_data",
            //   frequency: Duration(seconds: 10),
            //   initialDelay: Duration(seconds: 5),
            //   // constraints: Constraints(
            //   //   networkType: NetworkType.connected,
            //   // ),
            // );
          },
          child: const Text('Click!'),
        ),
      ),
    );
  }
}