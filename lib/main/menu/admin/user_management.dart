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




/*Future<String?> getUserInfo(String role) async {
      try {
        CollectionReference users =
        FirebaseFirestore.instance.collection('admin');
        final snapshot = await users.doc(role).get();
        final data = snapshot.data() as Map<String, dynamic>;
        return data['role'];

      } catch (e) {
        return 'Error fetching user';

      }
    }*/


/*final provUser = Provider.of<MyUser?>(context);

    if (provUser == null) {
      return Login();
    } else {
      if () {
        return AdminScreen();
      } else {
        return Login();
      }

    }*/


/*class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  String role = "user";

  @override
  void initState() {
    super.initState();
    _checkRole();
  }

  void _checkRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    final DocumentSnapshot snap = await FirebaseFirestore.instance.collection("admin")
        .doc(user!.uid).get();

    setState(() {
      role = snap[role];
    });

    if (role == "admin") {
      navigateNext(AdminScreen());
    } else {
      navigateNext(Login());
    }
  }

  void navigateNext(Widget route) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => route));
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}*/
