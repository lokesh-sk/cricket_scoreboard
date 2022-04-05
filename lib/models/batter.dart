class Batter {
  int runs;
  int balls;
  int fours;
  int sixes;
  String status;
  String ref;

  Batter.newBatter(
      { this.runs = 0,
       this.balls = 0,
       this.fours = 0,
       this.sixes = 0,
       this.status = "Batting",
       required this.ref});

  Map<String,Object?> toJson(){
    return {
      "runs": runs,
      "balls": balls,
      "fours": fours,
      "sixes": sixes,
      "status": status,
      "ref": ref
    };
  }
}
