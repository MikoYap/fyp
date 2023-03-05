import 'package:flutter/material.dart';
import 'package:fyp/data/plant.dart';
import 'package:fyp/collection/plant_details.dart';


class PlantTile extends StatelessWidget {
  late final Plant plant;
  PlantTile({required this.plant});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width * 0.94,
      child: Card(
        elevation: 0,
        child: InkWell(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Plant image
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 5, top: 0, bottom: 5),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: size.width * 0.28,
                    minHeight: size.width * 0.28,
                    maxWidth: size.width * 0.28,
                    maxHeight: size.width * 0.28,
                  ),
                  child: Image.asset(
                      '${plant.image}',
                      fit: BoxFit.fill
                  ),
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Plant species
                  Container(
                    width: size.width * 0.6,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                      child: Text(
                        '${plant.species_name}',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),

                  // Plant common name
                  Container(
                    width: size.width * 0.6,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                      child: Text(
                        '${plant.common_name}',
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PlantDetails(plant: plant))
            );
          },
        ),
      ),
    );
  }

}