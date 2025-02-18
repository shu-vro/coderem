import 'package:coderem/ApiCalls/user_submissions_req.dart';
import 'package:coderem/Widgets/FutureBuilderCustom.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

class Submissions extends StatelessWidget {
  final String handle;
  final List<UserSubmission> submissions;
  const Submissions(
      {super.key, required this.handle, required this.submissions});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: submissions.length,
      itemBuilder: (context, index) {
        final submission = submissions[index];
        return Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            color: Color.fromARGB(28, 222, 157, 150),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                submission.verdict == "OK"
                    ? Icons.task_alt
                    : Icons.not_interested_outlined,
                color: submission.verdict == "OK" ? Colors.green : Colors.red,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        submission.problem.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        submission.problem.tags.join(", "),
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.schedule,
                    size: 16,
                  ),
                  SizedBox(width: 4),
                  Text(
                    timeago.format(
                      DateTime.fromMillisecondsSinceEpoch(
                          submission.creationTimeSeconds * 1000),
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
