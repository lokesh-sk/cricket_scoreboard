import 'package:flutter/material.dart';

class PlayersPage extends StatefulWidget {
  const PlayersPage({ Key? key }) : super(key: key);

  @override
  State<PlayersPage> createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayersPage> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("PlayersPage"));
  }
}