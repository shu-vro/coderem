import 'package:flutter/material.dart';

class Contests extends StatelessWidget {
  const Contests({super.key});

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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Codeforces Round #$index",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xffde9d96),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Text(
                          "Div $index",
                          style: TextStyle(fontSize: 12),
                        ),
                      )
                    ],
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
                        "#$index",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Text(index % 2 == 0 ? "+10" : "-5",
                          style: TextStyle(
                            color: index % 2 == 0 ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
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
