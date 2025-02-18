import 'package:coderem/ApiCalls/user_contests_req.dart';
import 'package:coderem/ApiCalls/user_req.dart';
import 'package:coderem/ApiCalls/user_submissions_req.dart';
import 'package:coderem/Widgets/Contests.dart';
import 'package:coderem/Widgets/FutureBuilderCustom.dart';
import 'package:coderem/Widgets/Introduction.dart';
import 'package:coderem/Widgets/Submissions.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<String?> _handleFuture;

  @override
  void initState() {
    super.initState();
    _handleFuture = _getHandle();
  }

  Future<String?> _getHandle() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('handle');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _handleFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/login');
          });
          return Container(); // Return an empty container while navigating
        } else {
          final handle = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Text(
                'coderem',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              actions: [
                Builder(
                  builder: (context) {
                    return IconButton(
                      icon: Icon(Icons.menu),
                      iconSize: 36,
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    );
                  },
                ),
              ],
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Color(0xffde9d96),
                    ),
                    child: Text(
                      'coderem',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  ListTile(
                    title: Text('Home'),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: Text('Logout'),
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.remove('handle');
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                  ),
                ],
              ),
            ),
            body: FutureBuilderCustom<User>(
              future: fetchUsers(handle),
              builder: (context, users) {
                final user = users.first;
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Container(
                          width: MediaQuery.of(context).size.width - 32,
                          height: MediaQuery.of(context).size.width - 32,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(user.titlePhoto),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Introduction(
                        name: user.handle,
                        rating: user.rating,
                        title: user.rank,
                        rank: user.maxRating.toString(),
                        contribution: user.contribution.toString(),
                      ),
                      FutureBuilderCustom<UserContest>(
                        future: fetchUserContests(handle),
                        builder: (context, contests) {
                          return FutureBuilderCustom<UserSubmission>(
                            future: fetchUserSubmissions(handle, 15),
                            builder: (context, submissions) {
                              return DefaultTabController(
                                length: 3,
                                child: Column(children: [
                                  Container(
                                    color: Colors.white,
                                    child: TabBar(
                                      tabs: [
                                        Tab(
                                          child: Text("Overview"),
                                        ),
                                        Tab(
                                          child: Text("Submission"),
                                        ),
                                        Tab(
                                          child: Text("Contest"),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    // device height - appbar height - tabbar height
                                    height: MediaQuery.of(context).size.height -
                                        AppBar().preferredSize.height -
                                        kToolbarHeight * 2 -
                                        MediaQuery.of(context).padding.top,
                                    child: TabBarView(
                                      children: [
                                        Icon(Icons.directions_car),
                                        Submissions(
                                          handle: handle,
                                          submissions: submissions,
                                        ),
                                        Contests(contests: contests),
                                      ],
                                    ),
                                  ),
                                ]),
                              );
                            },
                          );
                        },
                      )
                    ],
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }
}
