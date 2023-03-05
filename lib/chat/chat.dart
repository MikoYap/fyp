import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp/main/auth/auth.dart';
import 'package:fyp/main/menu/admin/user_management.dart';



class Chat extends StatefulWidget {
  final VoidCallback? onSignInPressed;
  const Chat({Key? key, this.onSignInPressed}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final AuthService _auth = AuthService();
  var currentUser = FirebaseAuth.instance.currentUser;

  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chat",
          style: TextStyle(
            color: Colors.green,
            fontSize: 25,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,

        /*flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[
                  Color.fromRGBO(7, 113, 9, 1),
                  Color.fromRGBO(199, 248, 0, 1)
                ]),
          ),*/


        actions: [
          PopupMenuButton(
              icon: Icon(
                Icons.more_vert,
                color: Colors.green,
              ),
              itemBuilder: (context) {
                return [
                  PopupMenuItem <int> (
                    value: 0,
                    child: Text("User Manual"),
                  ),

                  PopupMenuItem <int> (
                    value: 1,
                    child: Text("About Us"),
                  ),

                  PopupMenuItem <int> (
                    value: 2,
                    child: Text("Admin"),
                  ),
                ];
              },

              onSelected: (value) {
                if (value == 0) {
                  print("User Manual menu is selected.");
                } else if (value == 1) {
                  print("About Us menu is selected.");
                } else if (value == 2) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserManagement().userId()),
                  );
                }
              }
          ),
        ],
      ),

      body: Center(
          child: LayoutBuilder(
              builder: (context, constraints) {
                if (currentUser == null || currentUser!.isAnonymous == false) {
                  return Container(
                    /*padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/forest.png"),
                    fit: BoxFit.cover,
                  )
                ),*/
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Have any question?\nLet's talk to us!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),

                        SizedBox(
                          height: 10,
                        ),

                        ElevatedButton(
                          child: Text("OK"),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          ),
                          onPressed: () async {
                            dynamic result = await _auth.signInAnonymous();
                            if (result == null) {
                              //give error notification;

                            } else {
                              widget.onSignInPressed!();

                            }
                          },
                        ),

                      ],
                    ),
                  );

                } else {
                  print("This is anonymous uid");
                  print(currentUser?.uid);

                  return FutureBuilder(
                      future: toUserScreen(context),
                      builder: (context, snapshot) {
                        return Center(child: CircularProgressIndicator());

                      }
                  );

                }
              }
          )
      ),
    );
  }

  Future<void> toUserScreen(BuildContext context) async {
    await Future.delayed(Duration(seconds: 1), () async {
      widget.onSignInPressed!();
    });
  }
}
