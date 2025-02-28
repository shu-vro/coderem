import 'dart:convert';
import 'package:http/http.dart' as http;

class Problem {
  final int contestId;
  final String index;
  final String name;
  final String type;
  final double points;
  final double rating;
  final List<String> tags;

  Problem({
    required this.contestId,
    required this.index,
    required this.name,
    required this.type,
    required this.points,
    required this.rating,
    required this.tags,
  });

  factory Problem.fromJson(Map<String, dynamic> json) {
    return Problem(
      contestId: json['contestId'] ?? 0,
      index: json['index'] ?? '',
      name: json['name'] ?? '',
      type: json['type'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      points: (json['points'] ?? 0).toDouble(),
      tags: List<String>.from(json['tags'] ?? []),
    );
  }
}

class Author {
  final int contestId;
  final List<Member> members;
  final String participantType;
  final bool ghost;
  final int room;
  final int startTimeSeconds;

  Author({
    required this.contestId,
    required this.members,
    required this.participantType,
    required this.ghost,
    required this.room,
    required this.startTimeSeconds,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      contestId: json['contestId'] ?? 0,
      members: List<Member>.from(
          (json['members'] ?? []).map((x) => Member.fromJson(x))),
      participantType: json['participantType'] ?? '',
      ghost: json['ghost'] ?? false,
      room: json['room'] ?? 0,
      startTimeSeconds: json['startTimeSeconds'] ?? 0,
    );
  }
}

class Member {
  final String handle;

  Member({required this.handle});

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      handle: json['handle'] ?? '',
    );
  }
}

class UserSubmission {
  final int id;
  final int contestId;
  final int creationTimeSeconds;
  final int relativeTimeSeconds;
  final Problem problem;
  final Author author;
  final String programmingLanguage;
  final String verdict;
  final String testset;
  final int passedTestCount;
  final int timeConsumedMillis;
  final int memoryConsumedBytes;

  UserSubmission({
    required this.id,
    required this.contestId,
    required this.creationTimeSeconds,
    required this.relativeTimeSeconds,
    required this.problem,
    required this.author,
    required this.programmingLanguage,
    required this.verdict,
    required this.testset,
    required this.passedTestCount,
    required this.timeConsumedMillis,
    required this.memoryConsumedBytes,
  });

  factory UserSubmission.fromJson(Map<String, dynamic> json) {
    return UserSubmission(
      id: json['id'] ?? 0,
      contestId: json['contestId'] ?? 0,
      creationTimeSeconds: json['creationTimeSeconds'] ?? 0,
      relativeTimeSeconds: json['relativeTimeSeconds'] ?? 0,
      problem: Problem.fromJson(json['problem'] ?? {}),
      author: Author.fromJson(json['author'] ?? {}),
      programmingLanguage: json['programmingLanguage'] ?? '',
      verdict: json['verdict'] ?? '',
      testset: json['testset'] ?? '',
      passedTestCount: json['passedTestCount'] ?? 0,
      timeConsumedMillis: json['timeConsumedMillis'] ?? 0,
      memoryConsumedBytes: json['memoryConsumedBytes'] ?? 0,
    );
  }
}

Future<List<UserSubmission>> fetchUserSubmissions(
    String handle, int count) async {
  final response = await http
      .get(Uri.parse('https://codeforces.com/api/user.status?handle=$handle'));

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    if (jsonResponse['status'] == 'OK') {
      List<dynamic> results = jsonResponse['result'];
      return results.map((json) => UserSubmission.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load user submissions');
    }
  } else {
    throw Exception('Failed to load user submissions');
  }
}
