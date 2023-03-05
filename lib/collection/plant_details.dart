import 'package:flutter/material.dart';
import 'package:fyp/data/plant.dart';

class PlantDetails extends StatelessWidget {
  final Plant plant;
  PlantDetails({required this.plant});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 16.0,
            ),

            // Plant image
            Center(
              child: Image.asset(
                '${plant.image}',
                height: 300,
                fit: BoxFit.fill,
              ),

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
                        "${plant.family}",
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
                        "${plant.genus}",
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
                            "${plant.species_name}",
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
                        "${plant.common_name}",
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
      ),
    );
  }
}
