import 'dart:convert';
import 'package:flutter/services.dart' as rootBundle;
import 'package:fyp/data/plant.dart';


List<Plant> getPlants (String responseBody){
  var list = json.decode(responseBody) as List<dynamic>;
  var plants = list.map((e) => Plant.fromJson(e)).toList();
  return plants;
}

Future<List<Plant>> readJsonData() async {
  final jsonData = await rootBundle.rootBundle.loadString('assets/json/plant.json');
  return getPlants(jsonData);
}