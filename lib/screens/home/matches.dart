import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cricket_scoreboard/backend/db.dart';
import 'package:flutter/material.dart';

import 'mini_score_board.dart';

class MatchesPage extends StatefulWidget {
  final String uid;
  const MatchesPage({Key? key, required this.uid}) : super(key: key);

  @override
  State<MatchesPage> createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: dbService.getMatches(uid: widget.uid),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Unable to load matches");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("No matches"));
        }
        // return ListView(
        //   children: snapshot.data!.docs.map((DocumentSnapshot document) {
        //     return MiniScoreBoard(ref: document.reference);
        //   }).toList(),
        // );

        return PageView.builder(
          itemBuilder: (context, index) {
            return MiniScoreBoard(ref: snapshot.data!.docs[index].reference);
          },
          itemCount: snapshot.data!.size,
        );
      },
    );
  }
}
