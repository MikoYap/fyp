import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fyp/home/home.dart';
import 'package:fyp/collection/collection.dart';
import 'package:fyp/location/location.dart';
import 'package:fyp/chat/chat.dart';
import 'package:fyp/main/interface/my_flutter_app_icons.dart';
import 'package:fyp/qr_code_scanner/qr_code_scanner.dart';
import 'package:fyp/chat/user_chatroom.dart';



class BottomNavApp extends StatefulWidget {
  const BottomNavApp({Key? key}) : super(key: key);

  @override
  State<BottomNavApp> createState() => _BottomNavAppState();
}

class _BottomNavAppState extends State<BottomNavApp> {
  int currentTab = 0;


  final List<Widget> screens = [
    Home(),
    Collection(),
    Location(),
    Chat(),
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = Home();

  final FirebaseAuth _auth = FirebaseAuth.instance;



  _onSignInPressed() {
    String uid;
    FirebaseFirestore.instance.collection("users").doc(_auth.currentUser!.uid).get().then((doc) {
      if (doc.exists) {
        uid = doc.data()!["uid"];
        setState(() {
          currentScreen = UserChatroom(chatroomId: uid);
        });
      }
    });

  }


  @override
  Widget build(BuildContext context) {
    bool showFab = MediaQuery.of(context).viewInsets.bottom != 0;

    return Scaffold(
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),


      floatingActionButton: Visibility(
        visible: !showFab,
        child: Container(
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.only(bottom: 5),
          child: FloatingActionButton(
            child: Container(
              width: 60,
              height: 60,
              child: Icon(
                  Icons.qr_code_scanner,
                  size: 30
              ),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: <Color>[
                      Color.fromRGBO(7, 113, 9, 1),
                      Color.fromRGBO(199, 248, 0, 1)
                    ]
                ),
              ),
            ),

            onPressed: () {
              setState(() {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const QRCodeScanner()
                    )
                );
              });
            },

          ),
        ),

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,


      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget> [
              // Left tab bar icons
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Home icon
                  MaterialButton(
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = Home();
                        currentTab = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.home_rounded,
                          size: 20,
                          color: currentTab == 0 ? Colors.green : Colors.grey,
                        ),
                        Text(
                          '  Home  ',
                          style: TextStyle(
                            fontSize: 12,
                            color: currentTab == 0 ? Colors.green : Colors.grey),
                        )
                      ],
                    ),
                  ),

                  // Collection icon
                  MaterialButton(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = Collection();
                        currentTab = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          CustomIcons.leaf,
                          size: 20,
                          color: currentTab == 1 ? Colors.green : Colors.grey,
                        ),
                        Text(
                          'Collection',
                          style: TextStyle(
                            fontSize: 12,
                            color: currentTab == 1 ? Colors.green : Colors.grey),
                        )
                      ],
                    ),
                  )
                ],
              ),
              // Right tab bar icons
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location icon
                  MaterialButton(
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = Location();
                        currentTab = 2;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 20,
                          color: currentTab == 2 ? Colors.green : Colors.grey,
                        ),
                        Text(
                          'Location',
                          style: TextStyle(
                            fontSize: 12,
                            color: currentTab == 2 ? Colors.green : Colors.grey),
                        )
                      ],
                    ),
                  ),

                  // Chat icon
                  MaterialButton(
                    padding: EdgeInsets.symmetric(horizontal: 22),
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = Chat(
                          onSignInPressed: _onSignInPressed,
                        );
                        currentTab = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble,
                          size: 20,
                          color: currentTab == 3 ? Colors.green : Colors.grey,
                        ),
                        Text(
                          'Chat',
                          style: TextStyle(
                            fontSize: 12,
                            color: currentTab == 3 ? Colors.green : Colors.grey
                          ),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
