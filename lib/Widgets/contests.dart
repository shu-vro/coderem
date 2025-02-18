import 'dart:math';
import 'package:coderem/ApiCalls/user_contests_req.dart';
import 'package:flutter/material.dart';

class Contests extends StatelessWidget {
  final List<UserContest> contests;
  const Contests({super.key, required this.contests});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: min(contests.length, 15),
      itemBuilder: (context, index) {
        final contest = contests[index];
        return Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            color: Color.fromARGB(28, 222, 157, 150),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                contest.contestName,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Rank: ",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    "#${contest.rank}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  Text(
                    contest.newRating > contest.oldRating
                        ? "+${contest.newRating - contest.oldRating}"
                        : "${contest.newRating - contest.oldRating}",
                    style: TextStyle(
                      color: contest.newRating > contest.oldRating
                          ? Colors.green
                          : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
