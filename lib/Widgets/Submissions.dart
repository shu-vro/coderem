import 'package:flutter/material.dart';

class Submissions extends StatelessWidget {
  const Submissions({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 15,
      itemBuilder: (context, index) => Container(
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
              index % 2 == 0 ? Icons.task_alt : Icons.not_interested_outlined,
              color: index % 2 == 0 ? Colors.green : Colors.red,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Submission $index",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "implementation, math, dp",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ]),
              ),
            ),
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  size: 16,
                ),
                SizedBox(width: 4),
                Text("2 days ago"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
