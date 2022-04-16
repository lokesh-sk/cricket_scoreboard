import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cricket_scoreboard/backend/db.dart';
import 'package:cricket_scoreboard/screens/scoreboardpage/scoreboardpage.dart';
import 'package:flutter/material.dart';

class MiniScoreBoard extends StatefulWidget {
  final DocumentReference ref;
  const MiniScoreBoard({Key? key, required this.ref}) : super(key: key);

  @override
  State<MiniScoreBoard> createState() => _MiniScoreBoardState();
}

class _MiniScoreBoardState extends State<MiniScoreBoard> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: dbService.getSCoreBoard(ref: widget.ref),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Unable to load matches");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        return GestureDetector(
          onTap: () {
            dbService.scoreBoardCollection =
                widget.ref.collection("scoreboard");
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>  ScoreBoardPage(),
              ),
            );
          },
          child: ListTile(
            title: Text(
              snapshot.data!.docs.first.id,
            ),
          ),
        );
      },
    );
  }
}
