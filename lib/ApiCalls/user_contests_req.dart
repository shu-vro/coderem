import 'dart:convert';
import 'package:http/http.dart' as http;

class UserContest {
  final int contestId;
  final String contestName;
  final String handle;
  final int rank;
  final int ratingUpdateTimeSeconds;
  final int oldRating;
  final int newRating;

  UserContest({
    required this.contestId,
    required this.contestName,
    required this.handle,
    required this.rank,
    required this.ratingUpdateTimeSeconds,
    required this.oldRating,
    required this.newRating,
  });

  factory UserContest.fromJson(Map<String, dynamic> json) {
    return UserContest(
      contestId: json['contestId'],
      contestName: json['contestName'],
      handle: json['handle'],
      rank: json['rank'],
      ratingUpdateTimeSeconds: json['ratingUpdateTimeSeconds'],
      oldRating: json['oldRating'],
      newRating: json['newRating'],
    );
  }
}

Future<List<UserContest>> fetchUserContests(String handle) async {
  final response = await http
      .get(Uri.parse('https://codeforces.com/api/user.rating?handle=$handle'));

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    if (jsonResponse['status'] == 'OK') {
      List<dynamic> results = jsonResponse['result'];
      print(results.toString());
      return results
          .map((json) => UserContest.fromJson(json))
          .toList()
          .reversed
          .toList();
    } else {
      throw Exception('Failed to load user contests');
    }
  } else {
    throw Exception('Failed to load user contests');
  }
}
