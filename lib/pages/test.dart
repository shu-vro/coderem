import 'package:coderem/local_notifications.dart';
import 'package:flutter/material.dart';

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
            LocalNotifications.scheduledNotification(
              title: "whatever",
              body: "I want",
              payload: "https://google.com",
              startTimeSecond:
                  DateTime.now().millisecondsSinceEpoch ~/ 1000 + 10,
            );
          },
          child: const Text('Click!'),
        ),
      ),
    );
  }
}
