import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fyp/main/menu/admin/user_management.dart';
import 'package:fyp/main/menu/about_us.dart';
import 'package:fyp/data/location_data.dart';
import 'package:fyp/data/repository.dart';
import 'package:fyp/main/menu/user_manual.dart';



class Location extends StatefulWidget {
  const Location({Key? key}) : super(key: key);

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {

  late GoogleMapController mapController;
  final LatLng _center = const LatLng(3.32490, 101.75189);

  List<LocationData> _locations = <LocationData>[];
  List<LocationData> _locationsDisplay = <LocationData>[];

  @override
  void initState() {
    super.initState();
    readJsonLocationData().then((value) {
      setState(() {
        _locations.addAll(value);
        _locationsDisplay = _locations;
      });
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Location",
          style: TextStyle(
            color: Colors.green,
            fontSize: 25,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,

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

      body: GoogleMap(
        mapType: MapType.normal,
        markers: Set<Marker>.from(_locationsDisplay.map((location) => Marker(
          markerId: MarkerId(location.marker_id!),
          infoWindow: InfoWindow(title: location.name!),
          icon: BitmapDescriptor.defaultMarker,
          position: location.getLatLng(),
        ))),
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 18.0,
        ),
      ),
    );
  }
}
