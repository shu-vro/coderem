import 'dart:convert';
import 'package:http/http.dart' as http;

class Contest {
  final int id;
  final String name;
  final String type;
  final String phase;
  final bool frozen;
  final int durationSeconds;
  final int startTimeSeconds;
  final int relativeTimeSeconds;

  Contest({
    required this.id,
    required this.name,
    required this.type,
    required this.phase,
    required this.frozen,
    required this.durationSeconds,
    required this.startTimeSeconds,
    required this.relativeTimeSeconds,
  });

  factory Contest.fromJson(Map<String, dynamic> json) {
    return Contest(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      phase: json['phase'],
      frozen: json['frozen'],
      durationSeconds: json['durationSeconds'],
      startTimeSeconds: json['startTimeSeconds'],
      relativeTimeSeconds: json['relativeTimeSeconds'],
    );
  }
}

Future<List<Contest>> fetchContests() async {
  final response =
      await http.get(Uri.parse('https://codeforces.com/api/contest.list'));

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    if (jsonResponse['status'] == 'OK') {
      List<dynamic> results = jsonResponse['result'];
      // filter those contests which are phase = 'BEFORE'
      results =
          results.where((contest) => contest['phase'] == 'BEFORE').toList();
      return results
          .map((json) => Contest.fromJson(json))
          .toList()
          .reversed
          .toList();
    } else {
      throw Exception('Failed to load contests');
    }
  } else {
    throw Exception('Failed to load contests');
  }
}
