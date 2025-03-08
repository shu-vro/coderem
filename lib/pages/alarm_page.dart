import 'dart:convert';

import 'package:coderem/ApiCalls/all_contests_req.dart';
import 'package:coderem/Widgets/contest_list_item.dart';
import 'package:coderem/Widgets/future_builder_custom.dart';
import 'package:coderem/Widgets/interval_timer.dart';
import 'package:coderem/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({super.key});

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  final SharedPreferencesAsync prefs = SharedPreferencesAsync();

  Future<List<dynamic>> _fetchAndSaveContests() async {
    final serverContests = await fetchContests();
    await saveContestsOnSharedPreference(contests: serverContests);
    return getContestsFromSharedPreferences();
  }

  Future<List<dynamic>> getContestsFromSharedPreferences() async {
    final existingContestsData = await prefs.getString("contests");
    return existingContestsData != null ? jsonDecode(existingContestsData) : [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilderCustom(
        future: _fetchAndSaveContests(),
        builder: (context, contests) {
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300.0,
                floating: false,
                pinned: true,
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    // double shrinkOffset =
                    //     constraints.biggest.height - kToolbarHeight * 2;
                    // double shrinkFactor =
                    //     (shrinkOffset / (300 - kToolbarHeight)).clamp(0.0, 1.0);
                    // double fadeFactor = (1 - shrinkFactor).clamp(0.0, 1.0);

                    return FlexibleSpaceBar(
                      titlePadding:
                          const EdgeInsets.only(left: 16.0, bottom: 16.0),
                      background: Stack(
                        children: [
                          Positioned(
                            top: 60,
                            left: 0,
                            right: 0,
                            child: Opacity(
                              opacity: 1, // shrinkFactor,
                              child: Image.asset(
                                'assets/images/alarm.png',
                                height: 200,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                      title: Stack(
                        alignment: Alignment.center,
                        children: [
                          IntervalTimer(
                              startTimeSeconds: contests[0]['startTimeSeconds'],
                              shrinkFactor: 1), // shrinkFactor),
                          Opacity(
                            opacity: 0, // fadeFactor,
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
              SliverToBoxAdapter(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FilledButton.tonalIcon(
                    onPressed: () {
                      launchURL("https://codeforces.com/contests");
                    },
                    label: Text("Contests"),
                    iconAlignment: IconAlignment.end,
                    icon: Icon(Icons.open_in_new),
                  ),
                  IconButton.filledTonal(
                    onPressed: () {},
                    icon: Icon(Icons.settings_rounded),
                  ),
                ],
              )),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return ContestListItem(
                      contest: contests[index],
                      onAlarmChanged: (updatedContest) async {
                        await prefs.setString("contests", jsonEncode(contests));
                      },
                    );
                  },
                  childCount: contests.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
