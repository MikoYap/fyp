import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;
import 'package:fyp/data/plant_data.dart';
import 'package:fyp/data/location_data.dart';



List<Plant> getPlants (String responseBody){
  var list = json.decode(responseBody) as List<dynamic>;
  var plants = list.map((e) => Plant.fromJson(e)).toList();
  return plants;
}

Future<List<Plant>> readJsonPlantData() async {
  final jsonPlantData = await rootBundle.rootBundle.loadString("assets/json/plant.json");
  return getPlants(jsonPlantData);
}

List<LocationData> getLocations (String responseBody){
  var list = json.decode(responseBody) as List<dynamic>;
  var locations = list.map((e) => LocationData.fromJson(e)).toList();
  return locations;
}

Future<List<LocationData>> readJsonLocationData() async {
  final jsonLocationData = await rootBundle.rootBundle.loadString("assets/json/location.json");
  return getLocations(jsonLocationData);
}
