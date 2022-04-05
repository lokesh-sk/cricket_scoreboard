import 'package:flutter/material.dart';
import 'signin_page.dart';
import 'register_page.dart';

class AuthenticatePage extends StatefulWidget {
  const AuthenticatePage({Key? key}) : super(key: key);

  @override
  State<AuthenticatePage> createState() => _AuthenticatePageState();
}

class _AuthenticatePageState extends State<AuthenticatePage> {
  bool isSignIn = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSignIn ? const Text("SignIn") : const Text("Register"),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                isSignIn = !isSignIn;
              });
            },
            child: isSignIn
                ? const Text(
                    "register",
                    style: TextStyle(color: Colors.black),
                  )
                : const Text(
                    "SignIn",
                    style: TextStyle(color: Colors.black),
                  ),
          ),
        ],
      ),
      body: Padding(
        padding:const  EdgeInsets.all(18.0),
        child: isSignIn ? const SignInPage() : const RegisterPage(),
      ),
    );
  }
}
