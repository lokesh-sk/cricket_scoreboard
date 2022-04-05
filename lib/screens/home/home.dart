import 'package:cricket_scoreboard/backend/auth.dart';
import 'package:cricket_scoreboard/shared/text_field_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'matches.dart';
import 'new_matches.dart';
import 'players.dart';

class Home extends StatefulWidget {
  final String uid;
  const Home({Key? key, required this.uid}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool loading = false;
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "CricketScoreBoard",
        ),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                await authService.signOut();
              } on FirebaseAuthException catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(e.toString(),style: textStyle,),
                  ),
                );
              }
            },
            child:  Text("LogOut",style: textStyle,),
          ),
        ],
      ),
      body: (index == 0)
          ? MatchesPage(uid: widget.uid)
          : (index == 1)
              ? const NewMatchPage()
              : const PlayersPage(),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Matches",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_rounded),
            label: "New",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Players",
          ),
        ],
        currentIndex: index,
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
      ),
    );
  }
}
