import 'package:distribution/Models/userModel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel _userFromFirebaseUser(User user) {
    return user != null
        ? UserModel(
            uid: user.uid, email: user.email, username: user.phoneNumber)
        : null;
  }

// auth change user stream
  Stream<UserModel> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

// Signin anonymously
  Future<dynamic> signInAnom() async {
    try {
      UserCredential result = await FirebaseAuth.instance.signInAnonymously();
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Sign in with Email & Password
  Future<String> signUp({String email, String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return "Signed Up";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return "The password provided is too weak.";
      } else if (e.code == 'email-already-in-use') {
        return "The account already exists for that email.";
      } else {
        return "Something Went Wrong.";
      }
    } catch (e) {
      print(e);
    }
  }

  //SIGN OUT METHOD
  Future signOut() async {
    try {
      await _auth.signOut();
      print("User Signed out");
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
