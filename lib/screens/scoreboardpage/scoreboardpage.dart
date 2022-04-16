import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cricket_scoreboard/backend/db.dart';
import 'package:cricket_scoreboard/shared/text_field_styles.dart';
import 'package:flutter/material.dart';

import '../../models/batter.dart';
import '../../models/scoreboard.dart';

class ScoreBoardPage extends StatelessWidget {
  const ScoreBoardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: StreamBuilder<QuerySnapshot<ScoreBoard>>(
          stream: dbService.getMainScoreBoard(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
                return const Text('none');

              case ConnectionState.waiting:
                return const CircularProgressIndicator();

              case ConnectionState.active:
                var scoreBoard = snapshot.data!.docs.first.data();
                return ListView(
                  children: [
                    ScoreBoardCard(scoreBoard: scoreBoard),
                    BatterGroup(scoreBoard: scoreBoard),
                    ButtonsCheckbox()
                  ],
                );

              case ConnectionState.done:
                return const Text('DOne');
            }
          },
        ),
      ),
    );
  }
}

class BatterGroup extends StatelessWidget {
  final ScoreBoard scoreBoard;
  const BatterGroup({Key? key, required this.scoreBoard}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Column(
          children: [
            if (scoreBoard.striker != null)
                      BatterInfo(batter: scoreBoard.striker!, isStriker: true),
            if (scoreBoard.nonStriker != null)
                      BatterInfo(
                          batter: scoreBoard.nonStriker!, isStriker: false),
          ],
        ),
      ),
    );
  }
}

///Finished
class ScoreBoardCard extends StatelessWidget {
  final ScoreBoard scoreBoard;
  const ScoreBoardCard({Key? key, required this.scoreBoard}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Card(
        color: Colors.white,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Score ${scoreBoard.score}-${scoreBoard.wickets}',
                  style: scoreBoardTextSTyle,
                ),
                scoreBoard.firstInnings
                    ? Text(
                        'CRR - ${scoreBoard.score / (scoreBoard.overs / 6)}',
                        style: scoreBoardTextSTyle,
                      )
                    : Text(
                        'Target - ${scoreBoard.target}',
                        style: scoreBoardTextSTyle,
                      ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Overs - ${scoreBoard.overs ~/ 6}.${scoreBoard.overs % 6}/${scoreBoard.totalOvers / 6}',
                  style: scoreBoardTextSTyle,
                ),
                scoreBoard.firstInnings
                    ? Text(
                        'Projected Score - ${(scoreBoard.score / (scoreBoard.overs / 6)) * (scoreBoard.totalOvers / 6)}',
                        style: scoreBoardTextSTyle,
                      )
                    : Text(
                        'Need ${scoreBoard.target! - scoreBoard.score} from ${scoreBoard.totalOvers - scoreBoard.overs}',
                        style: scoreBoardTextSTyle,
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BatterInfo extends StatelessWidget {
  final Batter batter;
  final bool isStriker;
  const BatterInfo({Key? key, required this.batter, required this.isStriker})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot<Object?>>(
      stream: dbService.getPlayerName(ref: batter.ref),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return const Text('none');
          case ConnectionState.waiting:
            return const SizedBox(
            height: 10,
            );
          case ConnectionState.active:
            var name = snapshot.data!.get('name');
            return Card(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  isStriker ? Text('$name*') : Text(name),
                  Text('${batter.runs}(${batter.balls})'),
                  Text('${batter.fours}-4\'s'),
                  Text('${batter.sixes}-6\'s')
                ],
              ),
            );
          case ConnectionState.done:
            return const Text('done');
        }
      },
    );
  }
}

class ButtonsCheckbox extends StatefulWidget {
  const ButtonsCheckbox({Key? key}) : super(key: key);

  @override
  State<ButtonsCheckbox> createState() => _ButtonsCheckboxState();
}

class _ButtonsCheckboxState extends State<ButtonsCheckbox> {
  bool wide = false;
  bool noBall = false;
  bool byes = false;
  bool wicket = false;

  void onTap(int number) {
    print(number);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          width: double.infinity,
          child: Wrap(
            children: [
              numberAvatar(0, onTap),
              numberAvatar(1, onTap),
              numberAvatar(2, onTap),
              numberAvatar(3, onTap),
              numberAvatar(4, onTap),
              numberAvatar(5, onTap),
              numberAvatar(6, onTap),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ///wide
              Checkbox(
                value: wide,
                onChanged: (value) {
                  setState(() {
                    wide = !wide;
                    noBall = false;
                    byes = false;
                  });
                },
              ),
              const Text('wide'),
              const SizedBox(
                width: 20.0,
              ),

              ///noBall
              Checkbox(
                value: noBall,
                onChanged: (value) {
                  setState(() {
                    wide = false;
                    noBall = !noBall;
                  });
                },
              ),
              const Text('noBall'),
              const SizedBox(
                width: 20.0,
              ),

              ///byes
              Checkbox(
                value: byes,
                onChanged: (value) {
                  setState(() {
                    wide = false;
                    byes = !byes;
                  });
                },
              ),
              const Text('byes'),
              const SizedBox(
                width: 20.0,
              ),

              ///wicket
              Checkbox(
                value: wicket,
                onChanged: (value) {
                  setState(() {
                    wicket = !wicket;
                  });
                },
              ),
              const Text('wicket'),
              const SizedBox(
                width: 20.0,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget numberAvatar(int number, void Function(int) onTap) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: GestureDetector(
      onTap: () => onTap(number),
      child: CircleAvatar(
        child: Text('$number'),
      ),
    ),
  );
}
