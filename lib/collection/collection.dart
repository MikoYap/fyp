import 'package:flutter/material.dart';
import 'package:fyp/data/plant_data.dart';
import 'package:fyp/data/repository.dart';
import 'package:fyp/collection/plant_tile.dart';
import 'package:fyp/main/menu/admin/user_management.dart';
import 'package:fyp/main/menu/about_us.dart';
import 'package:fyp/main/menu/user_manual.dart';



class Collection extends StatefulWidget {
  const Collection({Key? key}) : super(key: key);

  @override
  State<Collection> createState() => _CollectionState();
}


class _CollectionState extends State<Collection> with WidgetsBindingObserver{
  List<Plant> _plants = <Plant>[];
  List<Plant> _plantsDisplay = <Plant>[];

  ScrollController scrollController = ScrollController();
  bool showbtn = false;

  final FocusNode myFocusNode = FocusNode();


  @override
  void initState() {
    super.initState();
    readJsonPlantData().then((value) {
      setState(() {
        _plants.addAll(value);
        _plantsDisplay = _plants;
      });
    });

    scrollController.addListener(() { //scroll listener
      double showoffset = 10.0; //Back to top button will show on scroll offset 10.0

      if(scrollController.offset > showoffset){
        showbtn = true;
      } else {
        showbtn = false;
      }
    });

    WidgetsBinding.instance.addObserver(this);
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    myFocusNode.dispose();
    super.dispose();
  }


  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final value = WidgetsBinding.instance.window.viewInsets.bottom;
    if (value == 0) {
      myFocusNode.unfocus();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "Collection",
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

      // Button scroll to top
      floatingActionButton: Container(
        height: 50,
        width: 50,
        child: FittedBox(
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 500),  //show/hide animation
            opacity: showbtn ? 1.0 : 0.0, //set obacity to 1 on visible, or hide
            child: FloatingActionButton(
              heroTag: "scrollToTopFab",
              onPressed: () {
                scrollController.animateTo( //go to top of scroll
                    0,  //scroll offset to go
                    duration: Duration(milliseconds: 500), //duration of scroll
                    curve:Curves.fastOutSlowIn //scroll type
                );
              },
              child: Icon(
                Icons.keyboard_arrow_up,
              ),
              backgroundColor: Color(0xFF133A1B),
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: Container(
          child: ListView.builder(
            controller: scrollController, //set controller
            itemBuilder: (context, index) {
              return index == 0
                  ? _searchBar() : PlantTile(plant: this._plantsDisplay[index - 1]);
            },
            itemCount: _plantsDisplay.length + 1,
          ),
        ),
      ),
    );
  }


  _searchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 25, horizontal: 15),
      child: TextField(
        autofocus: false,
        focusNode: myFocusNode,

        onChanged: (searchText) {
          searchText = searchText.toLowerCase();
          setState(() {
            _plantsDisplay = _plants.where((u) {
              var sp = u.species_name!.toLowerCase();
              var cm = u.common_name!.toLowerCase();
              return sp.contains(searchText) || cm.contains(searchText);
            }).toList();
          });
        },

        decoration: InputDecoration(
          labelText: "Find a species",
          prefixIcon: Icon(Icons.search),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(
              color: Colors.green,
              width: 1 ,
            ),
          ),
        ),
      ),
    );
  }
}
