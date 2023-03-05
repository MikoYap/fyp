import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp/main/model/my_user.dart';



class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  // Create user obj based on User
  MyUser? _userFromFirebaseUser(User? user) {
    return user != null ? MyUser(uid: user.uid) : null;
  }

  // Auth change user stream
  Stream <MyUser?> get user {
    return _auth.authStateChanges()
        .map((User? user) => _userFromFirebaseUser(user));
  }

  // Sign in anonymous
  Future signInAnonymous() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      //return _userFromFirebaseUser(user!);

      if (user != null) {
        print("Anony account created successfull");

        await _firestore.collection("users").doc(_auth.currentUser!.uid).set({
          "uid": _auth.currentUser!.uid,
        });
        return _userFromFirebaseUser(user!);
      }

    } catch(e) {
      print(e.toString());
      return null;

    }
  }

  // Login with email & password
  Future loginWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password
      );
      User? user = result.user;
      return _userFromFirebaseUser(user!);

    } catch(e) {
      print(e.toString());
      return null;

    }
  }

  // Logout
  Future logout() async {
    try{
      return await _auth.signOut();

    } catch(e) {
      print(e.toString());
      return null;

    }
  }





}