import 'package:distribution/Models/userModel.dart';
import 'package:distribution/screens/Authentication/authenticate.dart';
import 'package:distribution/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:distribution/screens/home/home.dart';
import 'package:distribution/screens/Authentication/authenticate.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Return eaither the Home Or the Authenticate Widget
    final user = Provider.of<UserModel>(context);
    print(user);
    if (user == null) {
      return authenticate();
    } else {
      return Home();
    }
  }
}
