import 'package:cricket_scoreboard/backend/auth.dart';
import 'package:cricket_scoreboard/backend/db.dart';
import 'package:cricket_scoreboard/shared/text_field_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String email = "";
  String password = "";
  String confirmPassword = "";
  String error = "";
  bool loading = false;
  String teamName = "";
  @override
  Widget build(BuildContext context) {
    if (loading == false) {
      return ListView(
        children: [
          TextField(
            onChanged: ((value) => email = value),
            decoration: inputDecoration(labelText: "Email"),
          ),
          const SizedBox(height: 20.0,),
          TextField(
            onChanged: (value) => password = value,
            decoration: inputDecoration(labelText: "Password"),
          ),
          const SizedBox(height: 20.0,),
          TextField(
            onChanged: (value) => confirmPassword = value,
            decoration: inputDecoration(labelText: "Confirm Password"),
          ),
          const SizedBox(height: 20.0,),
          TextField(
            onChanged: (value) => teamName = value,
            decoration: inputDecoration(labelText: "Team Name"),
          ),
          const SizedBox(height: 20.0,),
          ElevatedButton(
              onPressed: () async {
                if (confirmPassword != password) {
                  setState(() {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Password Mismatch",style: textStyle,),
                      ),
                    );
                  });
                } else if (teamName == "") {
                  setState(() {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Team Name Required",style: textStyle,),
                      ),
                    );
                  });
                } else {
                  setState(() {
                    loading = true;
                  });
                  try {
                    String uid =
                        await authService.createUserWithEmailAndPassword(
                            email: email, password: password);
                    await dbService.createNewUser(uid: uid, teamName: teamName);
                  } on FirebaseAuthException catch (e) {
                    setState(() {
                      loading = false;
                      ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.code,style: textStyle,),
                      ),
                    );
                    });
                  } catch (e) {
                    setState(() {
                      loading = false;
                      ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString(),style: textStyle,),
                      ),
                    );
                    });
                  }
                }
              },
              child:  Text("Register",style: textStyle,)),
         
        ],
      );
    }
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
