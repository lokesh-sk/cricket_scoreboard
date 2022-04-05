import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cricket_scoreboard/models/scoreboard.dart';

import '../models/batter.dart';

class DataBaseService {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  late CollectionReference userCollection;
  late CollectionReference playersCollection;
  late CollectionReference matchesCollection;
  DataBaseService(FirebaseFirestore db) {
    _db = db;
    userCollection = _db.collection("users");
  }

  Future<void> createNewUser(
      {required String uid, required String teamName}) async {
    return await userCollection.doc(uid).set({"teamName": teamName});
  }

  Stream<QuerySnapshot> getSCoreBoard({required DocumentReference ref}) {
    return ref
        .collection("scoreboard")
        .orderBy("time", descending: true)
        .limit(1)
        .snapshots();
  }

  Stream<QuerySnapshot> getMatches({required String uid}) {
    return matchesCollection
        .orderBy("time", descending: true)
        .snapshots();
  }

  Future<Batter> getOrCreatePlayers({required String playerName}) async {
    var result = await playersCollection
        .where("name", isEqualTo: playerName)
        .limit(1)
        .get();
    if (result.docs.isNotEmpty) {
      return Batter.newBatter(ref: result.docs.first.id);
    }

    ///if player not exists
    var ref = await playersCollection.add({"name": playerName});
    return Batter.newBatter(ref: ref.id);
  }

  Future<void> createNewFirstInningsMatch(
      {required String opponentTeamName,
      required int totalOvers,
      required int noOfPlayers,
      required String strikerName,
      required String nonStrikerName}) async {
    Batter striker = await getOrCreatePlayers(playerName: strikerName);
    Batter nonStriker = await getOrCreatePlayers(playerName: nonStrikerName);
    ScoreBoard scoreBoard = ScoreBoard.newMatchFirstInnings(
        opponentTeamName: opponentTeamName,
        striker: striker,
        nonStriker: nonStriker,
        totalOvers: totalOvers * 6,
        totalWickets: noOfPlayers - 1);
    var matchId = await matchesCollection.add({"time": Timestamp.now()});
    matchId.collection("scoreboard").add(scoreBoard.toJson());
  }
}

DataBaseService dbService = DataBaseService(FirebaseFirestore.instance);
