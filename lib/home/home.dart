import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shadow_overlay/shadow_overlay.dart';
import 'package:fyp/main/menu/admin/user_management.dart';
import 'package:fyp/main/menu/about_us.dart';
import 'package:fyp/main/menu/user_manual.dart';



class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final homeImages = [
    "assets/images/sp1/sp1a.jpg",
    "assets/images/sp1/sp1c.jpg",
    "assets/images/sp1/sp1e.jpg",
    "assets/images/sp2/sp2b.jpg",
    "assets/images/sp2/sp2f.jpg",
    "assets/images/sp2/sp2g.jpg",
    "assets/images/sp2/sp2h.jpg"
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home",
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
                colors: <Color>[Color.fromRGBO(7, 113, 9, 1), Color.fromRGBO(199, 248, 0, 1)]),
          ),
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

      body: SingleChildScrollView(
        child: Column(
          children: [
            // Home Page Slidable Image Part
            Stack(
              children: [
                CarouselSlider.builder(
                  options: CarouselOptions(
                    height: 400,
                    viewportFraction: 1,
                    autoPlay: true,
                  ),
                  itemCount: homeImages.length,
                  itemBuilder: (context, index, realIndex) {
                    final homeImage = homeImages[index];
                    return buildImage(homeImage, index);
                  },
                ),

                Positioned(
                  bottom: 20,
                  left: 15,
                  child: Container(
                    width: size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome to",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),

                        Text(
                          "Ulu Gombak \nForest Reserve",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 36,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Start your adventure today!
            Container(
              width: size.width,
              color: Colors.green.shade50,
              padding: EdgeInsets.only(top: 30, left: 15, right: 15, bottom: 0),
              child: Text(
                "Start your adventure today!",
                style: TextStyle(
                  color: Colors.green.shade900,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  fontFamily: "alkatra",
                ),
              ),
            ),

            // Forest Reserve Information
            Container(
              width: size.width,
              color: Colors.green.shade50,
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: RichText(
                textAlign: TextAlign.justify,
                text: TextSpan(
                  text: "\nUlu Gombak Forest Reserve",
                  style: TextStyle(
                    color: Colors.black,
                    height: 1.5,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),

                  children: const <TextSpan> [
                    TextSpan(
                      text: " is located at the border of Selangor and Pahang, "
                      "covering an area of approximately 4,286 hectares. It serves as an important "
                      "water catchment area for the Klang Valley, providing a crucial source of fresh "
                      "water for the region.\n            The forest reserve is home to a diverse range of flora "
                          "and fauna, including rare and endangered species. The forest reserve also "
                          "serves as a site for research and education, allowing visitors to learn about "
                          "the natural world and its importance for the ecosystem. Over the years, the "
                          "reserve has been the focus of numerous conservation efforts to preserve its "
                          "ecological significance and protect its wildlife. Visitors to the reserve can "
                          "enjoy activities such as trekking, camping, and bird watching. There are also "
                          "several well-maintained trails and picnic areas for visitors to enjoy the "
                          "natural beauty of the forest reserve.",
                      style: TextStyle(
                        color: Colors.black,
                        height: 1.5,
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ]
                ),
              ),
            ),
          ]
        ),
      ),
    );
  }

  Widget buildImage(String homeImage, int index) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      color: Colors.grey,
      child: ShadowOverlay(
        shadowHeight: 200,
        shadowWidth: size.width,
        shadowColor: Colors.black,
        child: Image.asset(
          homeImage,
          width: size.width,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
