import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_5.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';



class AdminChatroom extends StatefulWidget {
  final String chatroomId;
  final String chatroomName;
  AdminChatroom({required this.chatroomId, required this.chatroomName});

  @override
  State<AdminChatroom> createState() => _AdminChatroomState();
}

class _AdminChatroomState extends State<AdminChatroom> {

  final TextEditingController _message = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int _previousMessageCount = 0;
  var _isScrolledToBottom = true;
  File? imageFile;


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool _isCallbackCalled = true;


    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.chatroomName,
          style: TextStyle(fontSize: 18),
        ),
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
            Navigator.pop(context);
          },
        ),
      ),

      body: Column(
        children: [

          // Chat messages build up
          Expanded(
            child: Container(
              width: size.width,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection("chatroom")
                    .doc(widget.chatroomId)
                    .collection("chats")
                    .orderBy("time", descending: false)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot>snapshot) {

                  if (snapshot.data != null) {
                    return ListView.builder(
                        controller: _scrollController,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {

                          // When Admin open chatroom, will directly scroll to lowest
                          if (_isCallbackCalled && _isScrolledToBottom) {
                            SchedulerBinding.instance.addPostFrameCallback((_) {
                              _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent,
                                  duration: Duration(milliseconds: 400),
                                  curve: Curves.easeOut
                              );
                            });
                          };
                          _isCallbackCalled = false;

                          // When opposite send message, will directly scroll to lowest
                          SchedulerBinding.instance.addPostFrameCallback((_) {
                            int currentMessageCount = snapshot.data!.docs.length + 1;
                            if (_previousMessageCount < currentMessageCount && _isScrolledToBottom) {
                              _scrollController.animateTo(
                                  _scrollController.position.maxScrollExtent,
                                  duration: Duration(milliseconds: 200),
                                  curve: Curves.easeOut
                              );
                              _previousMessageCount = currentMessageCount;
                            }
                          });

                          _scrollController.addListener(() {
                            if (_scrollController.offset >= _scrollController.position.maxScrollExtent - 1) {
                              _isScrolledToBottom = true;
                            } else {
                              _isScrolledToBottom = false;
                            }
                          });

                          Map<String, dynamic> map = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                          return messageType(size, map, context);

                        }
                    );

                  } else {
                    return Center(child: CircularProgressIndicator());
                  }

                },
              ),

            ),
          ),

          SizedBox(
            height: 10,
          ),

          // Text field
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: size.height / 15,
                width: size.width / 1.32,
                child: TextField(
                  controller: _message,
                  minLines: 1,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: "Message",
                    contentPadding: EdgeInsets.symmetric(vertical: 2, horizontal: 15),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(
                        color: Colors.green,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.photo),
                      onPressed: () => getImage(),
                    ),
                  ),
                ),
              ),

              SizedBox(
                width: 5,
              ),

              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.green,
                child: IconButton(
                  icon: Icon(
                    Icons.send,
                    color: Colors.white,
                    size: 18,
                  ),
                  onPressed: onSendMessage,
                ),
              ),

            ],
          ),

          SizedBox(
            height: 10,
          ),


        ],
      ),
    );
  }


  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        "sendby": "Admin",
        "messages": _message.text,
        "type": "text",
        "time": FieldValue.serverTimestamp(),
        "read": true,
      };

      await _firestore
          .collection("chatroom")
          .doc(widget.chatroomId)
          .collection("chats")
          .add(messageMap);

      await _firestore
          .collection("chatroom")
          .doc(widget.chatroomId).set({
        "time": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      _message.clear();
      _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 200),
          curve: Curves.easeOut
      );

    } else {
      print("Enter Some Text");
    }
  }


  Future getImage() async {
    ImagePicker _picker = ImagePicker();

    await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage();
      }
    });
  }


  Future uploadImage() async {
    String fileName = Uuid().v1();
    int status = 1;

    await _firestore
        .collection("chatroom")
        .doc(widget.chatroomId)
        .collection("chats")
        .doc(fileName)
        .set({
          "sendby": "Admin",
          "messages": "",
          "type": "img",
          "time": FieldValue.serverTimestamp(),
          "read": true,
        });

    await _firestore
        .collection("chatroom")
        .doc(widget.chatroomId).set({
          "uid": widget.chatroomId,
          "time": FieldValue.serverTimestamp(),
        });

    var ref = FirebaseStorage.instance.ref().child("images").child("$fileName.jpg");

    var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
      await _firestore
          .collection("chatroom")
          .doc(widget.chatroomId)
          .collection("chats")
          .doc(fileName)
          .delete();

      status = 0;
    });

    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();
      await _firestore
          .collection("chatroom")
          .doc(widget.chatroomId)
          .collection("chats")
          .doc(fileName).update({
        "messages": imageUrl
      });

      print(imageUrl);
    }
  }


  Widget messageType(Size size, Map<String, dynamic> map, BuildContext context) {
    return map["type"] == "text"

    // Text message
        ? Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: <Widget>[

              map["sendby"] == "Admin"
                  ? ChatBubble(
                clipper: ChatBubbleClipper5(type: BubbleType.sendBubble),
                alignment: Alignment.topRight,
                margin: EdgeInsets.only(top: 5, bottom: 5, right: 10),
                backGroundColor: Color(0xFF133A1B),
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: size.width * 0.7,
                  ),
                  child: Text(
                    map["messages"],
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )

                  : ChatBubble(
                clipper: ChatBubbleClipper5(type: BubbleType.receiverBubble),
                backGroundColor: Colors.white,
                margin: EdgeInsets.only(top: 5, bottom: 5, left: 10),
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: size.width * 0.7,
                  ),
                  child: Text(
                    map["messages"],
                    style: TextStyle(color: Color(0xFF133A1B)),
                  ),
                ),
              ),

            ],
          ),
        ),
      ],
    )

    // Image message
        : Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: <Widget>[

              map["sendby"] == "Admin"
                  ? ChatBubble(
                clipper: ChatBubbleClipper5(type: BubbleType.sendBubble),
                alignment: Alignment.topRight,
                margin: EdgeInsets.only(top: 5, bottom: 5, right: 10),
                backGroundColor: Color(0xFF133A1B),
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: size.width * 0.7,
                  ),
                  child: InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => showImage(
                          imageUrl: map["messages"],
                        ),
                      ),
                    ),
                    child: Container(
                      height: size.height / 2.5,
                      width: size.width / 2,
                      decoration: BoxDecoration(border: Border.all()),
                      alignment: map["messages"] != null ? null : Alignment.center,
                      child: map["messages"] != null
                          ? Image.network(
                        map["messages"],
                        fit: BoxFit.cover,
                      )
                          : CircularProgressIndicator(),
                    ),
                  ),
                ),
              )

                  : ChatBubble(
                clipper: ChatBubbleClipper5(type: BubbleType.receiverBubble),
                backGroundColor: Colors.white,
                margin: EdgeInsets.only(top: 5, bottom: 5, left: 10),
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: size.width * 0.7,
                  ),
                  child: InkWell(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => showImage(
                          imageUrl: map["messages"],
                        ),
                      ),
                    ),
                    child: Container(
                      height: size.height / 2.5,
                      width: size.width / 2,
                      decoration: BoxDecoration(border: Border.all()),
                      alignment: map["messages"] != null ? null : Alignment.center,
                      child: map["messages"] != null
                          ? Image.network(
                        map["messages"],
                        fit: BoxFit.cover,
                      )
                          : CircularProgressIndicator(),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ],
    );
  }

}


class showImage extends StatelessWidget {
  final String imageUrl;

  const showImage({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.black,
        child: Image.network(imageUrl),
      ),
    );
  }
}
