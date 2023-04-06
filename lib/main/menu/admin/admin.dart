import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:fyp/main/menu/admin/admin_chatroom.dart';
import 'package:fyp/main/auth/auth.dart';
import 'package:fyp/main/main.dart';



class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  final AuthService _auth = AuthService();
  bool isLoading = false;


  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: Text("Admin"),
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: <Color>[Color.fromRGBO(7, 113, 9, 1), Color.fromRGBO(199, 248, 0, 1)]),
          ),
        ),

        leadingWidth: 50,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          onPressed: () async {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyApp())
            );
          },
        ),

        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await _auth.logout();
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp())
              );
            },
          ),
        ],
      ),

      body: isLoading
        ? Center(
      child: Container(
        height: size.height / 20,
        width: size.width / 20,
        child: CircularProgressIndicator(),
      ),
    )

        : StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection("chatroom")
            .orderBy("time", descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data == null) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (BuildContext context, int index) {
              DocumentSnapshot documentSnapshot = snapshot.data!.docs[index];

              return StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection("chatroom")
                    .doc(documentSnapshot.id)
                    .collection("chats")
                    .orderBy("time", descending: true)
                    .limit(1)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return Center(child: CircularProgressIndicator());
                  }

                  Map<String, dynamic> map = snapshot.data!.docs[0].data() as Map<String, dynamic>;
                  bool isUnread = map["read"] == null;

                  // Slide each chat to left for more options
                  return Slidable(
                    endActionPane: ActionPane(
                      motion: const StretchMotion(),
                      children: [
                        // Delete message
                        SlidableAction(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: "Delete",
                          onPressed: (BuildContext context) async {
                            await _firestore
                                .collection("chatroom")
                                .doc(documentSnapshot.id)
                                .delete();
                          }
                        ),

                        // Unread message
                        SlidableAction(
                          onPressed: (BuildContext context) async {
                            await _firestore
                                .collection("chatroom")
                                .doc(documentSnapshot.id)
                                .collection("chats")
                                .get()
                                .then((snapshot) {
                              snapshot.docs.forEach((doc) async {
                                await _firestore
                                    .collection("chatroom")
                                    .doc(documentSnapshot.id)
                                    .collection("chats")
                                    .doc(doc.id)
                                    .set({
                                  "read": null
                                }, SetOptions(merge: true));
                              });
                            });
                            setState(() {
                              isUnread = true;
                            });
                          },
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          icon: Icons.mark_as_unread,
                          label: "Unread",
                        ),
                      ],
                    ),

                    child: ListTile(
                      title: Text(documentSnapshot["name"]),
                      subtitle: Text(
                        overflow: TextOverflow.ellipsis,
                        map["type"] == "text"
                            ? map["messages"] as String
                            : "Image",
                        style: map["read"] == null
                            ? TextStyle(color: Colors.teal)
                            : TextStyle(fontWeight: FontWeight.normal),
                      ),

                      trailing: isUnread == true
                          ? Icon(Icons.circle, color: Colors.green,)
                          : null,

                      onTap: () async {
                        await _firestore
                            .collection("chatroom")
                            .doc(documentSnapshot.id)
                            .collection("chats")
                            .get()
                            .then((snapshot) {
                              snapshot.docs.forEach((doc) async {
                                await _firestore
                                    .collection("chatroom")
                                    .doc(documentSnapshot.id)
                                    .collection("chats")
                                    .doc(doc.id)
                                    .set({
                                      "read": true
                                    }, SetOptions(merge: true));
                              });
                            });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return AdminChatroom(
                                chatroomId: documentSnapshot["uid"],
                                chatroomName: documentSnapshot["name"],);
                            },
                          )
                        );
                      },
                    ),
                  );
                }
              );
            },
          );
        }
      ),
    );
  }
}

