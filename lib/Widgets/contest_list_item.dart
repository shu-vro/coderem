import 'package:flutter/material.dart';
import 'package:coderem/utils/utils.dart';

class ContestListItem extends StatefulWidget {
  final Map<String, dynamic> contest;
  final Function(Map<String, dynamic>) onAlarmChanged;

  const ContestListItem({
    Key? key,
    required this.contest,
    required this.onAlarmChanged,
  }) : super(key: key);

  @override
  _ContestListItemState createState() => _ContestListItemState();
}

class _ContestListItemState extends State<ContestListItem> {
  String getTimeUntilStart(int startTimeSeconds) {
    final now = DateTime.now();
    final startTime =
        DateTime.fromMillisecondsSinceEpoch(startTimeSeconds * 1000);
    final difference = startTime.difference(now);

    if (difference.inDays >= 30) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months > 1 ? 's' : ''} remaining';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} remaining';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} remaining';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} remaining';
    } else {
      return 'Starting soon';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(28, 222, 157, 150),
        borderRadius: BorderRadius.circular(8),
        border: const Border(
          bottom: BorderSide(
            color: Color.fromARGB(117, 222, 157, 150),
            width: 1.0,
          ),
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: ListTile(
        title: Text(
          widget.contest['name'],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: Column(
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                formatTime(widget.contest['startTimeSeconds'])['hour']
                    .toString(),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                formatTime(widget.contest['startTimeSeconds'])['minute']
                    .toString(),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
              ),
            ),
          ],
        ),
        subtitle: Text(
          '${formatTime(widget.contest['startTimeSeconds'])['time'].toString()} - ${getTimeUntilStart(widget.contest['startTimeSeconds'])}',
          style: TextStyle(
            color: Colors.grey[800],
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Switch(
          value: widget.contest['alarm'],
          onChanged: (value) async {
            setState(() {
              widget.contest['alarm'] = value;
            });
            widget.onAlarmChanged(widget.contest);
          },
        ),
      ),
    );
  }
}
