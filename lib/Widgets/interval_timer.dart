import 'dart:async';
import 'package:flutter/material.dart';

class IntervalTimer extends StatefulWidget {
  final int startTimeSeconds;
  final double shrinkFactor;

  const IntervalTimer(
      {Key? key, required this.startTimeSeconds, required this.shrinkFactor})
      : super(key: key);

  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

String getTimeUntilStart(int startTimeSeconds) {
  final now = DateTime.now();
  final startTime =
      DateTime.fromMillisecondsSinceEpoch(startTimeSeconds * 1000);
  final difference = startTime.difference(now);

  if (difference.inDays >= 30) {
    final months = (difference.inDays / 30).floor();
    return '$months month${months > 1 ? 's' : ''} remaining';
  } else if (difference.inDays >= 7) {
    final weeks = (difference.inDays / 7).floor();
    return '$weeks week${weeks > 1 ? 's' : ''} remaining';
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

class _TimerWidgetState extends State<IntervalTimer> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // return Container(
    //   padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
    //   child: FittedBox(
    //     fit: BoxFit.scaleDown,
    //     child: Text(
    //       getTimeUntilStart(widget.startTimeSeconds),
    //       style: TextStyle(
    //         fontSize: 20,
    //         fontWeight: FontWeight.bold,
    //       ),
    //     ),
    //   ),
    // );
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Opacity(
          opacity: widget.shrinkFactor, // Fade out effect
          child: Text(
            getTimeUntilStart(widget.startTimeSeconds),
            style: TextStyle(
              fontSize: 20 + (20 * widget.shrinkFactor),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
