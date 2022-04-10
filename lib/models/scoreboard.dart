import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';

import 'batter.dart';

class ScoreBoard {
  String opponentTeamName;
  int score;
  int wickets;
  int overs;
  int totalWickets;
  int totalOvers;
  bool firstInnings;
  int? target;
  List<String> playersBatted;
  Batter? striker;
  Batter? nonStriker;
  Map<String, Batter> scoreCard;
  Timestamp time;

  ScoreBoard({
    required this.opponentTeamName,
    required this.score,
    required this.wickets,
    required this.overs,
    required this.totalWickets,
    required this.totalOvers,
    required this.firstInnings,
    this.target,
    required this.playersBatted,
    this.striker,
    this.nonStriker,
    required this.scoreCard,
    required this.time
  });

  ScoreBoard copyWith({
    String? opponentTeamName,
    int? score,
    int? wickets,
    int? overs,
    int? totalWickets,
    int? totalOvers,
    bool? firstInnings,
    int? target,
    List<String>? playersBatted,
    Batter? striker,
    Batter? nonStriker,
    Map<String, Batter>? scoreCard,
    Timestamp? time
  }) {
    return ScoreBoard(
      opponentTeamName: opponentTeamName ?? this.opponentTeamName,
      score: score ?? this.score,
      wickets: wickets ?? this.wickets,
      overs: overs ?? this.overs,
      totalWickets: totalWickets ?? this.totalWickets,
      totalOvers: totalOvers ?? this.totalOvers,
      firstInnings: firstInnings ?? this.firstInnings,
      target: target ?? this.target,
      playersBatted: playersBatted ?? this.playersBatted,
      striker: striker ?? this.striker,
      nonStriker: nonStriker ?? this.nonStriker,
      scoreCard: scoreCard ?? this.scoreCard,
      time: time ?? this.time
    );
  }

  Map<String, Object?> toMap() {
    final result = <String, Object?>{};

    result.addAll({'opponentTeamName': opponentTeamName});
    result.addAll({'score': score});
    result.addAll({'wickets': wickets});
    result.addAll({'overs': overs});
    result.addAll({'totalWickets': totalWickets});
    result.addAll({'totalOvers': totalOvers});
    result.addAll({'firstInnings': firstInnings});
    if (target != null) {
      result.addAll({'target': target});
    }
    result.addAll({'playersBatted': playersBatted});
    if (striker != null) {
      result.addAll({'striker': striker!.toMap()});
    }
    if (nonStriker != null) {
      result.addAll({'nonStriker': nonStriker!.toMap()});
    }
    result.addAll({
      'scoreCard': scoreCard.map((key, value) => MapEntry(key, value.toMap()))
    });
    result.addAll({'time': time});
    print("excecuted tomap");
    return result;
  }

  factory ScoreBoard.fromMap(Map<String, Object?> map) {
    print("excecuted fromMap");
    return ScoreBoard(
      opponentTeamName: map['opponentTeamName'] as String,
      score: (map['score'] as int).toInt(),
      wickets: (map['wickets'] as int).toInt(),
      overs: (map['overs'] as int).toInt(),
      totalWickets: (map['totalWickets'] as int).toInt(),
      totalOvers: (map['totalOvers'] as int).toInt(),
      firstInnings: map['firstInnings'] as bool,
      target: (map['target'] != null) ? map['target'] as int : null,
      playersBatted: (map['playersBatted'] as List).cast<String>(),
      striker: map['striker'] != null ? Batter.fromMap(map['striker'] as Map<String,dynamic>) : null,
      nonStriker:
          map['nonStriker'] != null ? Batter.fromMap(map['nonStriker']  as Map<String,dynamic>) : null,
      scoreCard: (map['scoreCard'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, Batter.fromMap(value))),
      time: map['time'] as Timestamp
    );
  }

  String toJson() => json.encode(toMap());

  factory ScoreBoard.fromJson(String source) =>
      ScoreBoard.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ScoreBoard(opponentTeamName: $opponentTeamName, score: $score, wickets: $wickets, overs: $overs, totalWickets: $totalWickets, totalOvers: $totalOvers, firstInnings: $firstInnings, target: $target, playersBatted: $playersBatted, striker: $striker, nonStriker: $nonStriker, scoreCard: $scoreCard, time: $time)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final collectionEquals = const DeepCollectionEquality().equals;

    return other is ScoreBoard &&
        other.opponentTeamName == opponentTeamName &&
        other.score == score &&
        other.wickets == wickets &&
        other.overs == overs &&
        other.totalWickets == totalWickets &&
        other.totalOvers == totalOvers &&
        other.firstInnings == firstInnings &&
        other.target == target &&
        collectionEquals(other.playersBatted, playersBatted) &&
        other.striker == striker &&
        other.nonStriker == nonStriker &&
        collectionEquals(other.scoreCard, scoreCard);
  }

  @override
  int get hashCode {
    return opponentTeamName.hashCode ^
        score.hashCode ^
        wickets.hashCode ^
        overs.hashCode ^
        totalWickets.hashCode ^
        totalOvers.hashCode ^
        firstInnings.hashCode ^
        target.hashCode ^
        playersBatted.hashCode ^
        striker.hashCode ^
        nonStriker.hashCode ^
        scoreCard.hashCode;
  }
}
