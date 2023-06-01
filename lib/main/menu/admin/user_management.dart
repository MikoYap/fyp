import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fyp/main/menu/admin/login.dart';
import 'package:fyp/main/menu/admin/admin.dart';


class UserManagement {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  userId() {
    var currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return Login();

    } else if (currentUser.isAnonymous) {
      return Login();

    } else {
      CollectionReference admin = _firestore.collection('Admin');
      return FutureBuilder<DocumentSnapshot>(
        future: admin.doc("ADM").get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;

            if (data["role"] == "admin") {
              return Admin();
            }
          }

          return Scaffold(
            body: Center(
              child: SpinKitChasingDots(
                size: 120,
                color: Colors.green,
                duration: const Duration(seconds: 1),

              ),
            ),
          );
        },
      );
    }
  }
}
