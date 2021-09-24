import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:distribution/Models/userModel.dart';
import 'package:distribution/screens/home/sell_category/catalogProductCard.dart';
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
  Future signIn({String email, String password}) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
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

  Stream<List<Product>> getAllproducts() {
    return FirebaseFirestore.instance
        .collection("products")
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Product.fromSnapshot(doc)).toList();
    });
  }
}
