import 'package:coderem/ApiCalls/all_contests_req.dart';
import 'package:coderem/Widgets/future_builder_custom.dart';
import 'package:coderem/Widgets/interval_timer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AlarmPage extends StatelessWidget {
  const AlarmPage({super.key});

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

  String formatTime(int startTimeSeconds) {
    final startTime =
        DateTime.fromMillisecondsSinceEpoch(startTimeSeconds * 1000);
    final formatter = DateFormat.jm(); // Format time as "8:30 AM"
    return formatter.format(startTime);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilderCustom(
      future: fetchContests(),
      builder: (context, contests) {
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // The SliverAppBar now includes an image that fades away on scroll.
              SliverAppBar(
                expandedHeight: 300.0,
                floating: false,
                pinned: true,
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    // Calculate how much space is left
                    double shrinkOffset =
                        constraints.biggest.height - kToolbarHeight * 2;
                    // Normalize the shrink factor between 0 and 1
                    double shrinkFactor =
                        (shrinkOffset / (300 - kToolbarHeight)).clamp(0.0, 1.0);

                    // Create a fade effect for text transitions
                    double fadeFactor = (1 - shrinkFactor).clamp(0.0, 1.0);

                    return FlexibleSpaceBar(
                      titlePadding:
                          const EdgeInsets.only(left: 16.0, bottom: 16.0),
                      // The background contains the fading image.
                      background: Stack(
                        children: [
                          // Positioned the image at the top center.
                          Positioned(
                            top: 60,
                            left: 0,
                            right: 0,
                            child: Opacity(
                              opacity: shrinkFactor,
                              child: Image.asset(
                                'assets/images/alarm.png',
                                height: 200,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Title text transitions smoothly from "time left" to "Alarm"
                      title: Stack(
                        alignment: Alignment.center,
                        children: [
                          IntervalTimer(
                              startTimeSeconds: contests[0].startTimeSeconds,
                              shrinkFactor: shrinkFactor),
                          Opacity(
                            opacity: fadeFactor, // Fade in effect
                            child: const Text(
                              "Alarm",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      centerTitle: true,
                    );
                  },
                ),
              ),
              // The list below the app bar.
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 6.0, horizontal: 16.0),
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
                      margin: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 8.0),
                      child: ListTile(
                        title: Text(
                          formatTime(contests[index].startTimeSeconds),
                        ),
                        subtitle: Text(getTimeUntilStart(
                            contests[index].startTimeSeconds)),
                        trailing: Switch(value: true, onChanged: (value) {}),
                      ),
                    );
                  },
                  childCount: contests.length,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
