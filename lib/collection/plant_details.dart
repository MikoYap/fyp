import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scroll_navigation/scroll_navigation.dart';
import 'package:fyp/data/plant.dart';



class PlantDetails extends StatefulWidget {
  final Plant plant;
  PlantDetails({required this.plant});

  @override
  State<StatefulWidget> createState() => PlantDetailsState();
}

class PlantDetailsState extends State<PlantDetails> {
  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.green,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.plant.species_name}",
          overflow: TextOverflow.ellipsis,
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

      body: Scrollbar(
        child: ScrollNavigation(
          bodyStyle: NavigationBodyStyle(
            background: Colors.white,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          barStyle: NavigationBarStyle(
            position: NavigationPosition.top,
            background: Colors.white,
            elevation: 0,
          ),
          identiferStyle: NavigationIdentiferStyle(
            color: Colors.green,
          ),

          pages: [
            // Information page
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 25,
                  ),

                  // Plant family
                  Container(
                    margin: EdgeInsets.fromLTRB(25, 0, 25, 15),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Family:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 5,
                        ),

                        Row(
                          children: [
                            Text(
                              "${widget.plant.family}",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  // Plant genus
                  Container(
                    margin: EdgeInsets.fromLTRB(25, 0, 25, 15),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Genus:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 5,
                        ),

                        Row(
                          children: [
                            Text(
                              "${widget.plant.genus}",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  // Plant species
                  Container(
                    margin: EdgeInsets.fromLTRB(25, 0, 25, 15),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Species:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 5,
                        ),

                        Row(
                          children: [
                            Flexible(
                                child: Text(
                                  "${widget.plant.species_name}",
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 14,
                                  ),
                                )
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  // Plant common name
                  Container(
                    margin: EdgeInsets.fromLTRB(25, 0, 25, 15),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Common name:",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          height: 5,
                        ),

                        Row(
                          children: [
                            Text(
                              "${widget.plant.common_name}",
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Image page
            Container(
              child: GridView.builder(
                itemCount: widget.plant.images!.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return Scaffold(
                              appBar: AppBar(
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
                              body: Center(
                                child: Image.asset(
                                  widget.plant.images![index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          }
                        )
                      );
                    },
                    child: Container(
                      child: Image.asset(
                        widget.plant.images![index],
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                }
              ),
            ),
          ],

          items: const [
            ScrollNavigationItem(icon: Icon(Icons.info, color: Colors.green)),
            ScrollNavigationItem(icon: Icon(Icons.image, color: Colors.green)),
          ],
        ),
      ),



      /*SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),

            // Plant image
            CarouselSlider.builder(
              itemCount: widget.plant.images!.length,
              itemBuilder: (context, index, realIndex) {
                final plantImage = widget.plant.images![index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  child: buildImage(plantImage, index),
                );
              },
              options: CarouselOptions(
                height: size.height / 2.1,
                onPageChanged: (index, reason) {
                  setState(() {
                    activeIndex = index;
                  });
                }
              )
            ),

            SizedBox(
              height: 10.0,
            ),



            SizedBox(
              height: 25.0,
            ),

            // Plant family
            Container(
              margin: EdgeInsets.fromLTRB(25, 0, 25, 15),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Family:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Text(
                        "${widget.plant.family}",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),

            // Plant genus
            Container(
              margin: EdgeInsets.fromLTRB(25, 0, 25, 15),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Genus:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Text(
                        "${widget.plant.genus}",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),

            // Plant species
            Container(
              margin: EdgeInsets.fromLTRB(25, 0, 25, 15),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Species:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Flexible(
                          child: Text(
                            "${widget.plant.species_name}",
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 16,
                            ),
                          )
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Plant common name
            Container(
              margin: EdgeInsets.fromLTRB(25, 0, 25, 15),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Common name:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Text(
                        "${widget.plant.common_name}",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),

          ],
        ),
      ),*/

    );
  }

  Widget buildImage(String imageFile, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      child: Image.asset(imageFile, fit: BoxFit.cover),
    );
  }
}





/*

Widget buildIndicator() {
  return AnimatedSmoothIndicator(
      effect: ExpandingDotsEffect(dotWidth: 8, dotHeight: 8, activeDotColor: Colors.green),
      activeIndex: activeIndex,
      count: widget.plant.images!.length
  );
}*/

