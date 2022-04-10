import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cricket_scoreboard/models/scoreboard.dart';

import '../models/batter.dart';

class DataBaseService {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  late CollectionReference userCollection;
  late CollectionReference playersCollection;
  late CollectionReference matchesCollection;
  late CollectionReference scoreBoardCollection;

  DataBaseService(FirebaseFirestore db) {
    _db = db;
    userCollection = _db.collection("users");
  }

  Future<void> createNewUser(
      {required String uid, required String teamName}) async {
    await userCollection.doc(uid).set({"teamName": teamName});
    teamName = teamName;
  }

  setTeamName({required String uid}) async {
    //var result = await userCollection.doc(uid).get();
  }

  ///Matches Page ScoreBoard
  Stream<QuerySnapshot<ScoreBoard>> getSCoreBoard(
      {required DocumentReference ref}) {
    return ref
        .collection("scoreboard")
        .orderBy("time", descending: true)
        .limit(1)
        .withConverter<ScoreBoard>(
            fromFirestore: (snapshot, _) =>
                ScoreBoard.fromMap(snapshot.data()!),
            toFirestore: (scoreBoard, _) => scoreBoard.toMap())
        .snapshots();
  }

  Stream<QuerySnapshot> getMatches({required String uid}) {
    return matchesCollection.orderBy("time", descending: true).snapshots();
  }

  ///Get Or Create The New Players
  Future<Batter> getOrCreatePlayers({required String playerName}) async {
    var result = await playersCollection
        .where("name", isEqualTo: playerName)
        .limit(1)
        .get();
    if (result.docs.isNotEmpty) {
      return Batter(ref: result.docs.first.id);
    }

    ///if player not exists
    var ref = await playersCollection.add({"name": playerName});
    return Batter(ref: ref.id);
  }

  ///New First Innings Match
  Future<void> createNewFirstInningsMatch(
      {required String opponentTeamName,
      required int totalOvers,
      required int noOfPlayers,
      required String strikerName,
      required String nonStrikerName}) async {
    Batter striker = await getOrCreatePlayers(playerName: strikerName);
    Batter nonStriker = await getOrCreatePlayers(playerName: nonStrikerName);
    List<String> playersBatted = [striker.ref, nonStriker.ref];
    Map<String, Batter> scoreCard = {
      striker.ref: striker,
      nonStriker.ref: nonStriker
    };

    ScoreBoard scoreBoard = ScoreBoard(
        opponentTeamName: opponentTeamName,
        striker: striker,
        nonStriker: nonStriker,
        totalOvers: totalOvers * 6,
        totalWickets: noOfPlayers - 1,
        firstInnings: true,
        overs: 0,
        score: 0,
        wickets: 0,
        playersBatted: playersBatted,
        scoreCard: scoreCard,
        time: Timestamp.now());
    var matchId = await matchesCollection.add({"time": Timestamp.now()});
    scoreBoardCollection = matchId.collection("scoreboard");
    scoreBoardCollection.add(scoreBoard.toMap());
  }

  /// New Second Innings Match
  Future<void> createNewSecondInningsMatch(
      {required String opponentTeamName,
      required int totalOvers,
      required int noOfPlayers,
      required int target,
      required String strikerName,
      required String nonStrikerName}) async {
    Batter striker = await getOrCreatePlayers(playerName: strikerName);
    Batter nonStriker = await getOrCreatePlayers(playerName: nonStrikerName);
    List<String> playersBatted = [striker.ref, nonStriker.ref];
    Map<String, Batter> scoreCard = {
      striker.ref: striker,
      nonStriker.ref: nonStriker
    };
    ScoreBoard scoreBoard = ScoreBoard(
        opponentTeamName: opponentTeamName,
        striker: striker,
        nonStriker: nonStriker,
        totalOvers: totalOvers * 6,
        totalWickets: noOfPlayers - 1,
        target: target,
        firstInnings: false,
        overs: 0,
        score: 0,
        wickets: 0,
        playersBatted: playersBatted,
        scoreCard: scoreCard,
        time: Timestamp.now());
    var matchId = await matchesCollection.add({"time": Timestamp.now()});
    scoreBoardCollection = matchId.collection("scoreboard");
    scoreBoardCollection.add(scoreBoard.toMap());
  }

  Query<ScoreBoard> getMainScoreBoard() {
    return scoreBoardCollection
        .orderBy("time", descending: true)
        .limit(1)
        .withConverter<ScoreBoard>(
            fromFirestore: (snapshot, _) =>
                ScoreBoard.fromMap(snapshot.data()!),
            toFirestore: (scoreBoard,_) => scoreBoard.toMap());
  }
}

DataBaseService dbService = DataBaseService(FirebaseFirestore.instance);
