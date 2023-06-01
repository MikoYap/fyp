import 'package:flutter/material.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import 'package:fyp/data/plant_data.dart';


class PlantWebPage extends StatelessWidget {

  final Plant plant;
  PlantWebPage({required this.plant});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 50,
        leading: IconButton(
          icon: const Icon(Icons.clear),
          color: Colors.green,
          onPressed: () async {
            Navigator.pop(context);
          },
        ),
      ),

      body: WebViewPlus(
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (controller) {
            controller.loadUrl("${plant.link}");
          }
      ),
    );
  }
}
