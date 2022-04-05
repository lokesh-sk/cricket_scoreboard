import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../backend/auth.dart';
import '../../shared/text_field_styles.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String email = "";
  String password = "";
  String error = "";
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    if (loading == false) {
      return ListView(
        children: [
          TextField(
            onChanged: ((value) => email = value),
            decoration: inputDecoration(labelText: "Email"),
          ),
          const SizedBox(
            height: 20.0,
          ),
          TextField(
            onChanged: (value) => password = value,
            decoration: inputDecoration(labelText: "Password"),
          ),
          const SizedBox(
            height: 20.0,
          ),
          ElevatedButton(
              onPressed: () async {
                setState(() {
                  loading = true;
                });
                try {
                  await authService.signInWithEmailAndPassword(
                      email: email, password: password);
                } on FirebaseAuthException catch (e) {
                  setState(() {
                    loading = false;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.code,style: textStyle,),
                      ),
                    );
                  });
                }
              },
              child:  Text("SignIn",style: textStyle,)),
          
        ],
      );
    }
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
