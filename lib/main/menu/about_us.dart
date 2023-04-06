import 'package:flutter/material.dart';


class AboutUs extends StatelessWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "About Us",
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
      backgroundColor: Colors.white,

      body: Container(
        alignment: Alignment.topCenter,
        margin: EdgeInsets.only(top: 150),
        child: Image.asset(
          "assets/images/um_logo.png",
          height: 250,
          width: 250,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
