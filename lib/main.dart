import 'package:coderem/Widgets/Contests.dart';
import 'package:coderem/Widgets/Introduction.dart';
import 'package:coderem/Widgets/Submissions.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xffde9d96),
            surface: Color.fromARGB(255, 252, 244, 240)),
        fontFamily: "TypoRound",
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'coderem',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            iconSize: 36,
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Padding(
            //   padding: EdgeInsets.all(16),
            //   child: Image.network(
            //     // "https://mertbulan.com/images/posts/layoffs.webp",
            //     "https://userpic.codeforces.org/4633111/title/1f9717122a8b6f7b.jpg",
            //     fit: BoxFit.cover,
            //   ),
            // ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Container(
                width: MediaQuery.of(context).size.width - 32,
                height: MediaQuery.of(context).size.width - 32,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      "https://userpic.codeforces.org/4633111/title/1f9717122a8b6f7b.jpg",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Introduction(
              name: "Shirshen Shuvro",
              rating: 3991,
              title: "Legendary Grandmaster",
              rank: "1",
              contribution: "264",
            ),
            DefaultTabController(
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
                      kToolbarHeight -
                      MediaQuery.of(context).padding.top * 2,
                  child: TabBarView(
                    children: [
                      Icon(Icons.directions_car),
                      Submissions(),
                      Contests(),
                    ],
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
