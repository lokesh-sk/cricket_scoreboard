import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cricket_scoreboard/backend/db.dart';
import 'package:flutter/material.dart';

import '../../models/scoreboard.dart';

class ScoreBoardPage extends StatelessWidget {
  const ScoreBoardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot<ScoreBoard>>(
        stream: dbService.getMainScoreBoard().snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<ScoreBoard>> snapshot) {
          if (snapshot.hasError) {
            return const Text("Unable to load matches");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          var scoreBoard = snapshot.requireData.docs.first.data();
          return Padding(
            padding: const EdgeInsets.all(18.0),
            child: ListView(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DataWidget(
                        title: "score",
                        content: scoreBoard.score.toString(),
                      ),
                    ),
                    const SizedBox(
                      width: 30.0,
                    ),
                    Expanded(
                      child: DataWidget(
                        title: "Wickets",
                        content: scoreBoard.wickets.toString(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30.0),
                Row(
                  children: [
                    Expanded(
                      child: DataWidget(
                        title: "overs",
                        content:
                            "${scoreBoard.overs ~/ 6}.${scoreBoard.overs % 6}/${scoreBoard.totalOvers / 6}",
                      ),
                    ),
                    const SizedBox(
                      width: 30.0,
                    ),
                    Expanded(
                      child: DataWidget(
                        title: "opponentTeamName",
                        content: scoreBoard.opponentTeamName.toString(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class DataWidget extends StatelessWidget {
  final String title;
  final String content;
  const DataWidget({Key? key, required this.title, required this.content})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      height: 85,
      child: Column(
        children: [
          Text(title),
          Text(content),
        ],
      ),
    );
  }
}
