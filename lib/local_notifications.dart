import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:developer';
import 'package:url_launcher/url_launcher.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class LocalNotifications {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_notification');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    // timezone
    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(
        currentTimeZone == "Asia/Dacca" ? "Asia/Dhaka" : currentTimeZone));

    try {
      await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onDidReceiveNotificationResponse:
              (NotificationResponse notificationResponse) async {
        log('Notification received: ${notificationResponse.payload}');
        if (notificationResponse.payload != null &&
            notificationResponse.payload!.isNotEmpty) {
          _launchURL(notificationResponse.payload!);
        }
      });

      // Handle if the app was launched via notification
      final details = await _flutterLocalNotificationsPlugin
          .getNotificationAppLaunchDetails();
      if (details != null && details.didNotificationLaunchApp) {
        final payload = details.notificationResponse?.payload ?? '';
        if (payload.isNotEmpty) {
          _launchURL(payload);
        }
      }
      await _requestPermissions();
    } catch (e) {
      log('Error initializing notifications: $e');
    }
  }

  static Future<void> showNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your_channel_id', 'your_channel_name',
            channelDescription: 'your_channel_description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    try {
      await _flutterLocalNotificationsPlugin
          .show(0, title, body, platformChannelSpecifics, payload: payload);
      log('Notification shown successfully: $title - $body');
    } catch (e) {
      log('Error showing notification: $e');
    }
  }

  static Future<void> scheduledNotification({
    int id = 1,
    required String title,
    required String body,
    required String payload,
    required int startTimeSecond,
  }) async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    final tz.TZDateTime scheduledDate =
        tz.TZDateTime.fromMillisecondsSinceEpoch(
            tz.local, startTimeSecond * 1000);

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your_other_channel_id', 'your_channel_name',
            channelDescription: 'your_channel_description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    final NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    try {
      // Check if the notification is already scheduled
      final List<PendingNotificationRequest> pendingNotificationRequests =
          await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
      final bool isAlreadyScheduled =
          pendingNotificationRequests.any((request) => request.id == id);

      if (!isAlreadyScheduled) {
        await _flutterLocalNotificationsPlugin
            .zonedSchedule(
          id,
          title,
          body,
          scheduledDate,
          platformChannelSpecifics,
          androidScheduleMode: AndroidScheduleMode.exact,
          matchDateTimeComponents: DateTimeComponents.time,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: payload,
        )
            .then((value) {
          log('Notification scheduled successfully  ${scheduledDate.toString()} currentTime: ${now.toString()}');
        });
      } else {
        log('Notification with id $id is already scheduled.');
      }
    } catch (e) {
      log('Error scheduling notification: $e');
    }
  }

  static Future<void> _launchURL(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        log('Could not launch $url');
      }
    } catch (e) {
      log('Error launching URL: $e');
    }
  }

  static Future<void> _requestPermissions() async {
    try {
      await Permission.notification.isDenied.then((value) {
        if (value) {
          Permission.notification.request();
          log('Notification permissions requested successfully');
        }
      });
    } catch (e) {
      log('Error requesting notification permissions: $e');
    }

    try {
      final a = AndroidFlutterLocalNotificationsPlugin();
      final accept = await a.requestExactAlarmsPermission();
      if (accept == true) {
        log('scheduleExactAlarm permissions requested successfully');
      }

      await Permission.scheduleExactAlarm.isDenied.then((value) {
        if (value) {
          Permission.scheduleExactAlarm.request();
          log('scheduleExactAlarm permissions requested successfully');
        }
      });
    } catch (e) {
      log("Error requesting alarm permissions: $e");
    }
  }

  static Future<void> cancelNotification(int id) async {
    try {
      await _flutterLocalNotificationsPlugin.cancel(id);
      log('Notification with id $id cancelled successfully');
    } catch (e) {
      log('Error cancelling notification: $e');
    }
  }

  static Future<void> cancelAllNotifications() async {
    try {
      await _flutterLocalNotificationsPlugin.cancelAll();
      log('All notifications cancelled successfully');
    } catch (e) {
      log('Error cancelling all notifications: $e');
    }
  }
}
