import 'package:distribution/Models/userModel.dart';
import 'package:flutter/material.dart';
import 'package:distribution/screens/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:distribution/services/auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel>.value(
        value: AuthService().user,
        initialData: null,
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Distrubtion App',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: Wrapper()));
  }
}
