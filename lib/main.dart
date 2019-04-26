import 'dart:async';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  Map<String, double> currentLocation = Map();
  StreamSubscription<Map<String, double>> locationSubscription;
  
  Location location = Location();
  bool loaded = false;
  String error;
  
  @override
  void initState() {
    super.initState();
    
//    currentLocation['latitude'] = 0.0;
//    currentLocation['longitude'] = 0.0;
    currentLocation['latitude'] = 72.22;
    currentLocation['longitude'] = -99.22;
    
    initPlatformState();
    locationSubscription = location.onLocationChanged().listen((Map<String, double> result){
      loaded = true;
      setState(() {
        currentLocation = result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('OnArrive'),
        ),
        body: Stack(
          children: <Widget>[
            FlutterMap(
              options: MapOptions(
//            center: LatLng(53.4565258, 14.4620756),
                center: LatLng(
                  loaded ? currentLocation['latitude'] : 34.0,
                  loaded ? currentLocation['longitude'] : -118.0
                ),
                zoom: 12,
              ),
              layers: [
                TileLayerOptions(
                  urlTemplate: "https://api.mapbox.com/styles/v1/threetins/cjuwo33sz045p1flkbqg384nm/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoidGhyZWV0aW5zIiwiYSI6ImNqdXJlMGQyYzFxZHo0ZG11amUxOXJhNXIifQ.W_XmHaHqyCZwypr7FCmlsw",
                  additionalOptions: {
                    'accessToken': 'pk.eyJ1IjoidGhyZWV0aW5zIiwiYSI6ImNqdXJlMGQyYzFxZHo0ZG11amUxOXJhNXIifQ.W_XmHaHqyCZwypr7FCmlsw',
                    'id': 'mapbox.mapbox-streets-v7',
                  },
                ),
              ],
            ),
            Center(
              child: Container(
                width: 50,
                height: 30,
                color: Colors.red,
              ),
            )
          ],
        ),
//        body: Center(
//          child: Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              Text(
//                'Lat/Lng:${currentLocation['latitude']}/${currentLocation['longitude']}',
//                style: TextStyle(
//                  fontSize: 20.0,
//                  color: Colors.blueAccent,
//                ),
//              )
//            ],
//          ),
//        ),
      ),
    );
  }
  
  void initPlatformState() async {
    Map<String, double> my_location;
    
    try {
      my_location = await location.getLocation();
      error = "";
    } on PlatformException catch(e) {
      if (e.code == 'PERMISSION_DENIED')
        error = 'Permission denied';
      else if (e.code == 'PERMISSION_DENIED_NEVER_ASK')
        error = 'Permission denied - please ask the user to enable from the app settings';
      my_location = null;
    }
    
    setState(() {
      currentLocation = my_location;
    });
  }
}

