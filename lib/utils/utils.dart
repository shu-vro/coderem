import 'dart:convert';
import 'dart:developer';

import 'package:coderem/ApiCalls/all_contests_req.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> saveContestsOnSharedPreference(
    {required List<Contest> contests}) async {
  final SharedPreferencesAsync prefs = SharedPreferencesAsync();
  final existingContestsData = await prefs.getString("contests");
  List<dynamic> existingContests =
      existingContestsData != null ? jsonDecode(existingContestsData) : [];

  // Create a map of existing contests for quick lookup
  final Map<String, dynamic> existingContestsMap = {
    for (var contest in existingContests) contest["name"]: contest
  };

  List<dynamic> updatedContests = [];
  for (var contest in contests) {
    updatedContests.add({
      "name": contest.name,
      "startTimeSeconds": contest.startTimeSeconds,
      "alarm": existingContestsMap[contest.name]?["alarm"] ?? true,
    });
  }

  // Save the updated contests to shared preferences
  await prefs.setString("contests", jsonEncode(updatedContests));
}

Map<String, String> formatTime(int startTimeSeconds) {
  final startTime =
      DateTime.fromMillisecondsSinceEpoch(startTimeSeconds * 1000);

  int hour = startTime.hour;
  final minute = startTime.minute;
  final amPm = hour < 12 ? 'AM' : 'PM';
  hour = hour % 12 == 0 ? 12 : hour % 12;

  return {
    'hour': hour.toString().padLeft(2, '0'),
    'minute': minute.toString().padLeft(2, '0'),
    'amPm': amPm,
    'time':
        '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $amPm',
  };
}

Future<void> launchURL(String url) async {
  try {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      log('Could not launch $url');
    }
  } catch (e) {
    log('Error launching URL: $e');
  }
}
