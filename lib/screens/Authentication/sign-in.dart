import 'package:flutter/material.dart';
import 'package:distribution/services/auth.dart';

class Signin extends StatefulWidget {
  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black12,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        elevation: 0.0,
        title: Text("Distribution App"),
        centerTitle: true,
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: RaisedButton(
              child: Text("Sign in"),
              onPressed: () async {
                dynamic result = await _auth.signInAnom();
                if (result == null) {
                  print("Error Occured");
                } else {
                  print("You Have Signed in");
                  print(result.uid);
                }
              })),
    );
  }
}
