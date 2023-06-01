import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp/main/auth/auth.dart';
import 'package:fyp/main/menu/admin/user_management.dart';
import 'package:fyp/main/menu/about_us.dart';
import 'package:fyp/main/menu/user_manual.dart';



class Chat extends StatefulWidget {
  final VoidCallback? onSignInPressed;
  const Chat({Key? key, this.onSignInPressed}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  var currentUser = FirebaseAuth.instance.currentUser;

  String name = "";
  String error = "";

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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserManual()),
                  );
                } else if (value == 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AboutUs()),
                  );
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
                // User haven't login
                if (currentUser == null || currentUser!.isAnonymous == false) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Have any question?\nLet's talk to us!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: "alkatra",
                            ),
                          ),

                          SizedBox(
                            height: 10,
                          ),

                          TextFormField(
                            decoration: InputDecoration(
                              hintText: "Enter your name",
                            ),
                            validator: (val) => val!.isEmpty ? "Enter a name" : null,
                            onChanged: (val) {
                              setState(() => name = val);
                            },
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
                              if (_formKey.currentState!.validate()) {
                                dynamic result = await _auth.signInAnonymous(name);
                                if (result == null) {
                                  setState(() => error = "Name is invalid");
                                } else {
                                  widget.onSignInPressed!();
                                }
                              }
                            },
                          ),

                          SizedBox(
                            height: 12,
                          ),

                          Text(
                            error,
                            style: TextStyle(color: Colors.red, fontSize: 14),
                          ),

                        ],
                      ),
                    ),
                  );

                  // User already login
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
