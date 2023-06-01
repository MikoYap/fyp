import 'package:google_maps_flutter/google_maps_flutter.dart';



class LocationData {
  String? marker_id;
  String? name;
  double? lat;
  double? lng;

  LocationData(
      {
        this.marker_id,
        this.name,
        this.lat,
        this.lng
      }
  );

  LocationData.fromJson(Map<String, dynamic> json) {
    marker_id = json["marker_id"];
    name = json["name"];
    lat = json["lat"];
    lng = json["lng"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["marker_id"] = this.marker_id;
    data["name"] = this.name;
    data["lat"] = this.lat;
    data["lng"] = this.lng;
    return data;
  }

  LatLng getLatLng() {
    return LatLng(lat!, lng!);
  }
}