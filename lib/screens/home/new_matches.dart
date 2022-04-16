import 'package:cricket_scoreboard/backend/db.dart';
import 'package:cricket_scoreboard/screens/scoreboardpage/scoreboardpage.dart';
import 'package:cricket_scoreboard/shared/text_field_styles.dart';
import 'package:flutter/material.dart';

class NewMatchPage extends StatefulWidget {
  const NewMatchPage({Key? key}) : super(key: key);

  @override
  State<NewMatchPage> createState() => _NewMatchPageState();
}

class _NewMatchPageState extends State<NewMatchPage> {
  String opponentTeamName = "";
  int totalOvers = 0;
  int noOfPlayers = 0;
  int? target;
  bool firstInnings = true;
  String strikerName = "";
  String nonStrikerName = "";
  bool loading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Opponent Team Name is Required";
                      }
                      return null;
                    },
                    onChanged: (value) => opponentTeamName = value,
                    decoration: inputDecoration(labelText: "Opponent Name"),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    onChanged: (value) => totalOvers = int.parse(value),
                    decoration: inputDecoration(labelText: "No Of Overs"),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "No Of Overs is required";
                      }
                      if (int.tryParse(value) == null) {
                        return "Number Required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    onChanged: (value) => noOfPlayers = int.parse(value),
                    decoration: inputDecoration(labelText: "No Of Players"),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "No Of Players is required";
                      }
                      if (int.tryParse(value) == null) {
                        return "Number Required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: [
                      Radio(
                        value: true,
                        groupValue: firstInnings,
                        onChanged: (value) {
                          setState(() {
                            firstInnings = !firstInnings;
                          });
                        },
                      ),
                      const Text("1st Innings"),
                      Radio(
                        value: false,
                        groupValue: firstInnings,
                        onChanged: (value) {
                          setState(() {
                            firstInnings = !firstInnings;
                          });
                        },
                      ),
                      const Text("2nd Innings"),
                    ],
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  if (firstInnings == false)
                    TextFormField(
                      onChanged: (value) => target = int.parse(value),
                      decoration: inputDecoration(labelText: "Target"),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Target is Required";
                        }
                        if (int.tryParse(value) == null) {
                          return "Number Required";
                        }
                        return null;
                      },
                    ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    onChanged: (value) => strikerName = value,
                    decoration: inputDecoration(labelText: "Striker Name"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Striker Name Cannot Be Empty";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    onChanged: (value) => nonStrikerName = value,
                    decoration: inputDecoration(labelText: "Non Striker Name"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Non Striker Name Cannot Be Empty";
                      }
                      if (value == strikerName) {
                        return "Striker and Non Striker Name Cannot Be Same";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Form Successfully Validated",
                              style: textStyle,
                            ),
                          ),
                        );
                        setState(() {
                          loading = true;
                        });
                        try {
                          if (firstInnings == true) {
                            await dbService.createNewFirstInningsMatch(
                                opponentTeamName: opponentTeamName,
                                totalOvers: totalOvers,
                                noOfPlayers: noOfPlayers,
                                strikerName: strikerName,
                                nonStrikerName: nonStrikerName);
                          } else {
                            await dbService.createNewSecondInningsMatch(
                                opponentTeamName: opponentTeamName,
                                totalOvers: totalOvers,
                                noOfPlayers: noOfPlayers,
                                target: target!,
                                strikerName: strikerName,
                                nonStrikerName: nonStrikerName);
                          }
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>  ScoreBoardPage()),);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                e.toString(),
                                style: textStyle,
                              ),
                            ),
                          );
                        }
                      }
                    },
                    child: const Text("Start match"),
                  ),
                ],
              ),
            ),
    );
  }
}
