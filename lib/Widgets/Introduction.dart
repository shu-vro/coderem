import 'package:flutter/material.dart';

class Introduction extends StatelessWidget {
  final String name;
  final int rating;
  final String title;
  final String rank;
  final String contribution;

  const Introduction({
    super.key,
    required this.name,
    required this.rating,
    required this.title,
    required this.rank,
    required this.contribution,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Rating: $rating",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red[800],
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SmallChips(
                  icon: Icon(Icons.emoji_events),
                  primaryColor: Colors.yellow[800] ?? Colors.yellow,
                  title: "Rank",
                  value: "#$rank",
                ),
                SmallChips(
                  icon: Icon(Icons.support),
                  primaryColor: Colors.blue,
                  title: "Contribution",
                  value: contribution,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SmallChips extends StatelessWidget {
  final Icon icon;
  final String title;
  final String value;
  final Color primaryColor;

  const SmallChips({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon.icon,
          color: primaryColor,
          size: 20,
        ),
        SizedBox(width: 4),
        Text(
          "$title: ",
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
