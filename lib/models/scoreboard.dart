import 'package:cloud_firestore/cloud_firestore.dart';

import 'batter.dart';

class ScoreBoard {
  String opponentTeamName;
  int score;
  int wickets;
  bool firstInnings;
  int? target;
  int totalWickets;
  int overs;
  int totalOvers;
  Batter? striker;
  Batter? nonStriker;
  late Timestamp time;
  List<String> playersBatted = [];
   Map<String, Object?> scoreCard = {};

  ScoreBoard(
      {required this.opponentTeamName,
      required this.score,
      required this.wickets,
      required this.firstInnings,
      required this.totalWickets,
      required this.overs,
      required this.totalOvers,
      required this.striker,
      required this.nonStriker,
      required this.playersBatted,
      required this.scoreCard,
      this.target});

  ScoreBoard.newMatchFirstInnings({
    required this.opponentTeamName,
    this.score = 0,
    this.wickets = 0,
    this.overs = 0,
    this.firstInnings = true,
    this.target = 0,
    required this.striker,
    required this.nonStriker,
    required this.totalOvers,
    required this.totalWickets,
  }) {
    playersBatted.add(striker!.ref);
    playersBatted.add(nonStriker!.ref);
    scoreCard[striker!.ref] = striker!.toJson();
    scoreCard[nonStriker!.ref] = nonStriker!.toJson();
    time = Timestamp.now();
  }

  ScoreBoard.newMatchSecondInnings({
    required this.opponentTeamName,
    this.score = 0,
    this.wickets = 0,
    this.overs = 0,
    this.firstInnings = false,
    required this.target,
    required this.striker,
    required this.nonStriker,
    required this.totalOvers,
    required this.totalWickets,
  }) {
    playersBatted.add(striker!.ref);
    playersBatted.add(nonStriker!.ref);
    scoreCard[striker!.ref] = striker!.toJson();
    scoreCard[nonStriker!.ref] = nonStriker!.toJson();
  }

  Map<String, Object?> toJson() {
    return {
      "score": score,
      "wickets": wickets,
      "firstInnings": firstInnings,
      "target": target,
      "totalWickets": totalWickets,
      "overs": overs,
      "totalOvers": totalOvers,
      "striker": striker?.toJson(),
      "nonStriker": nonStriker?.toJson(),
      "playersBatted": playersBatted,
      "scoreCard": scoreCard,
      "time": time
    };
  }
}
