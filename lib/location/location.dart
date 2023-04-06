import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fyp/main/menu/admin/user_management.dart';
import 'package:fyp/main/menu/about_us.dart';



class Location extends StatefulWidget {
  const Location({Key? key}) : super(key: key);

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(3.30197, 101.78273);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  static final Marker _uluGombakForestReserve = Marker(
    markerId: MarkerId("_uluGombakForestReserve"),
    infoWindow: InfoWindow(title: "Ulu Gombak Forest Reserve"),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(3.30197, 101.78273),
  );

  static final Marker _sp1 = Marker(
    markerId: MarkerId("_sp1"),
    infoWindow: InfoWindow(title: "Sp1"),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(3.32503, 101.75242),
  );


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
                  print("User Manual menu is selected.");
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
        markers: {
          _uluGombakForestReserve,
          _sp1,
        },
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 11.0,
        ),
      ),
    );
  }
}
