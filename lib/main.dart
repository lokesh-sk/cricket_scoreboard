import 'package:cricket_scoreboard/backend/auth.dart';
import 'package:cricket_scoreboard/backend/db.dart';
import 'package:cricket_scoreboard/screens/authentication/authentication.dart';
import 'package:cricket_scoreboard/screens/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// Returns the root widget cricketScoreBoard
  runApp(const MaterialApp(
    home: CricketScoreBoard(),
  ));
}

class CricketScoreBoard extends StatelessWidget {
  const CricketScoreBoard({Key? key}) : super(key: key);

  /// This Widget acts a the root widget
  /// it Will return the authentication pages if user is not signed in
  /// else it will return Home
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: authService.authStatusChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          dbService.matchesCollection = dbService.userCollection.doc(snapshot.data!.uid).collection("matches");
          dbService.playersCollection = dbService.userCollection.doc(snapshot.data!.uid).collection("players");
          return Home(uid: snapshot.data!.uid);
        }
        return const AuthenticatePage();
      },
    );
  }
}
