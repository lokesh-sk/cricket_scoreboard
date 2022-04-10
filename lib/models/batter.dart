import 'dart:convert';

class Batter {
  int runs;
  int balls;
  int fours;
  int sixes;
  String status;
  String ref;
  Batter({
     this.runs = 0,
     this.balls = 0,
     this.fours = 0,
     this.sixes = 0,
     this.status = "Batting",
    required this.ref,
  });

  Batter copyWith({
    int? runs,
    int? balls,
    int? fours,
    int? sixes,
    String? status,
    String? ref,
  }) {
    return Batter(
      runs: runs ?? this.runs,
      balls: balls ?? this.balls,
      fours: fours ?? this.fours,
      sixes: sixes ?? this.sixes,
      status: status ?? this.status,
      ref: ref ?? this.ref,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, Object>{};
  
    result.addAll({'runs': runs});
    result.addAll({'balls': balls});
    result.addAll({'fours': fours});
    result.addAll({'sixes': sixes});
    result.addAll({'status': status});
    result.addAll({'ref': ref});
  
    return result;
  }

  factory Batter.fromMap(Map<String, dynamic> map) {
    return Batter(
      runs: map['runs'] as int,
      balls: map['balls'] as int,
      fours: map['fours'] as int,
      sixes: map['sixes'] as int,
      status: map['status'] as String,
      ref: map['ref'] as String
    );
  }

  String toJson() => json.encode(toMap());

  factory Batter.fromJson(String source) => Batter.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Batter(runs: $runs, balls: $balls, fours: $fours, sixes: $sixes, status: $status, ref: $ref)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Batter &&
      other.runs == runs &&
      other.balls == balls &&
      other.fours == fours &&
      other.sixes == sixes &&
      other.status == status &&
      other.ref == ref;
  }

  @override
  int get hashCode {
    return runs.hashCode ^
      balls.hashCode ^
      fours.hashCode ^
      sixes.hashCode ^
      status.hashCode ^
      ref.hashCode;
  }
}
