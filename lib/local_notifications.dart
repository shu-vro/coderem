import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:developer';

class LocalNotifications {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    try {
      await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onDidReceiveNotificationResponse:
              (NotificationResponse notificationResponse) {});
      log('Notification plugin initialized successfully');
      await _requestPermissions();
    } catch (e) {
      log('Error initializing notification plugin: $e');
    }
  }

  static Future<void> showNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('your_channel_id', 'your_channel_name',
            channelDescription: 'your_channel_description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    try {
      await _flutterLocalNotificationsPlugin
          .show(0, title, body, notificationDetails, payload: payload);
    } catch (e) {
      log('Error showing notification: $e');
    }
  }

  static Future<void> _requestPermissions() async {
    try {
      // await _flutterLocalNotificationsPlugin
      //     .resolvePlatformSpecificImplementation<
      //         IOSFlutterLocalNotificationsPlugin>()
      //     ?.requestPermissions(
      //       alert: true,
      //       badge: true,
      //       sound: true,
      //     );
      // await _flutterLocalNotificationsPlugin
      //     .resolvePlatformSpecificImplementation<
      //         MacOSFlutterLocalNotificationsPlugin>()
      //     ?.requestPermissions(
      //       alert: true,
      //       badge: true,
      //       sound: true,
      //     );
      await Permission.notification.isDenied.then((value) {
        if (value) {
          Permission.notification.request();
        }
      });
      // await SystemChrome.setPreferredOrientations(
      //     [DeviceOrientation.portraitUp]);
      // await initFcm();
      log('Notification permissions requested successfully');
    } catch (e) {
      log('Error requesting notification permissions: $e');
    }
  }
}
