import 'dart:convert';
import 'package:http/http.dart' as http;

class User {
  final String lastName;
  final int lastOnlineTimeSeconds;
  final int rating;
  final int friendOfCount;
  final String titlePhoto;
  final String handle;
  final String avatar;
  final String firstName;
  final int contribution;
  final String organization;
  final String rank;
  final int maxRating;
  final int registrationTimeSeconds;
  final String maxRank;

  User({
    required this.lastName,
    required this.lastOnlineTimeSeconds,
    required this.rating,
    required this.friendOfCount,
    required this.titlePhoto,
    required this.handle,
    required this.avatar,
    required this.firstName,
    required this.contribution,
    required this.organization,
    required this.rank,
    required this.maxRating,
    required this.registrationTimeSeconds,
    required this.maxRank,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      lastName: json['lastName'] ?? '',
      lastOnlineTimeSeconds: json['lastOnlineTimeSeconds'] ?? 0,
      rating: json['rating'] ?? 0,
      friendOfCount: json['friendOfCount'] ?? 0,
      titlePhoto: json['titlePhoto'] ?? '',
      handle: json['handle'] ?? '',
      avatar: json['avatar'] ?? '',
      firstName: json['firstName'] ?? '',
      contribution: json['contribution'] ?? 0,
      organization: json['organization'] ?? '',
      rank: json['rank'] ?? '',
      maxRating: json['maxRating'] ?? 0,
      registrationTimeSeconds: json['registrationTimeSeconds'] ?? 0,
      maxRank: json['maxRank'] ?? '',
    );
  }
}

Future<List<User>> fetchUsers(String handle) async {
  final response = await http
      .get(Uri.parse('https://codeforces.com/api/user.info?handles=$handle'));

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonResponse = json.decode(response.body);
    if (jsonResponse['status'] == 'OK') {
      List<dynamic> results = jsonResponse['result'];
      return results.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  } else {
    throw Exception('Failed to load users');
  }
}
