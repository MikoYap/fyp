import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';



class UserManual extends StatefulWidget {
  const UserManual({Key? key}) : super(key: key);

  @override
  State<UserManual> createState() => _UserManualState();
}

class _UserManualState extends State<UserManual> {

  final manualImages = [
    "assets/imgs/user_manual/um_01.png",
    "assets/imgs/user_manual/um_02.png",
    "assets/imgs/user_manual/um_03.png",
    "assets/imgs/user_manual/um_04.png",
    "assets/imgs/user_manual/um_05.png",
    "assets/imgs/user_manual/um_06.png",
    "assets/imgs/user_manual/um_07.png"
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "User Manual",
          style: TextStyle(
            color: Colors.green,
            fontSize: 25,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,

        automaticallyImplyLeading: false,
        leadingWidth: 50,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_left),
          color: Colors.green,
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
      ),

      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10,),
        child: Column(
          children: [
            // Image slider
            CarouselSlider.builder(
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height/1.2,
                viewportFraction: 1,
                autoPlay: true,
              ),
              itemCount: manualImages.length,
              itemBuilder: (context, index, realIndex) {
                final manualImage = manualImages[index];
                return Container(
                  child: Image.asset(
                    manualImage,
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImage(String manualImage, int index) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      color: Colors.white,
      child: Image.asset(
        manualImage,
        height: size.height/1.2,
        width: size.width,
        fit: BoxFit.cover,
      ),

    );
  }
}