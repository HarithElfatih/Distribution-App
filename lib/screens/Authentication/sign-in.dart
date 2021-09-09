import 'package:flutter/material.dart';
import 'package:distribution/services/auth.dart';
import 'package:distribution/shared/constant.dart';

class Signin extends StatefulWidget {
  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();

  String email = "";
  String password = "";
  String error = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.amber,
        elevation: 0.0,
        title: Text("Distribution App"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Form(
          key: _formkey,
          child: Column(children: <Widget>[
            SizedBox(height: 20.0),
            TextFormField(
              decoration: textInputDecoration.copyWith(hintText: "Email"),
              validator: (val) => val.isEmpty ? "Enter Your Email" : null,
              onChanged: (val) {
                setState(() => email = val);
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: textInputDecoration.copyWith(hintText: "Password"),
              obscureText: true,
              validator: (val) => val.isEmpty ? "Enter Your Password" : null,
              onChanged: (val) {
                setState(() => password = val);
              },
            ),
            SizedBox(height: 20),
            RaisedButton(
              color: Colors.pink,
              child: Text("Sign in", style: TextStyle(color: Colors.white)),
              onPressed: () async {
                if (_formkey.currentState.validate()) {
                  dynamic result =
                      await _auth.signIn(email: email, password: password);
                  if (result == null) {
                    setState(() => error = "هناك خطاْ في طلبك");
                  }
                }
              },
            ),
            SizedBox(height: 20),
            Text(
              error,
              style: TextStyle(color: Colors.red, fontSize: 14),
            )
          ]),
        ),
      ),
    );
  }
}
