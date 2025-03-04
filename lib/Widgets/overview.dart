import 'package:coderem/ApiCalls/user_contests_req.dart';
import 'package:coderem/ApiCalls/user_req.dart';
import 'package:coderem/ApiCalls/user_submissions_req.dart';
import 'package:coderem/Widgets/bar_chart.dart';
import 'package:coderem/Widgets/pie_chart.dart';
import 'package:flutter/material.dart';

class Overview extends StatelessWidget {
  final User user;
  final List<UserContest> contests;
  final List<UserSubmission> submissions;
  const Overview(
      {super.key,
      required this.user,
      required this.contests,
      required this.submissions});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 180,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.all(16),
              children: [
                Tile(
                  title: "Max Rating",
                  value: user.maxRating.toString(),
                  icon: Icons.star_outline,
                ),
                SizedBox(width: 16),
                Tile(
                  title: "Total Submissions",
                  value: submissions.length.toString(),
                  icon: Icons.task_alt,
                ),
                SizedBox(width: 16),
                Tile(
                  title: "Total Contests",
                  value: contests.length.toString(),
                  icon: Icons.event_available_outlined,
                ),
                SizedBox(width: 16),
                Tile(
                  title: "Friends",
                  value: user.friendOfCount.toString(),
                  icon: Icons.favorite_border,
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Color(0x45ECAB85),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  "Submissions by Rating",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                BarChartSample3(submissions: submissions),
              ],
            ),
          ),
          SizedBox(height: 24),
          Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            margin: EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Color(0x45ECAB85),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  "Submissions by Language",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                PieChartCustom(submissions: submissions),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Tile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  const Tile(
      {super.key,
      required this.title,
      required this.value,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xffF19DC5),
            Color(0xffF89999),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 20),
                ),
                Opacity(
                  opacity: 0.5,
                  child: Icon(
                    icon,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: FittedBox(
                      alignment: Alignment.topLeft,
                      fit: BoxFit.scaleDown,
                      child: Text(
                        value,
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
