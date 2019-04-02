import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'GymTile.dart';
import 'package:xml/xml.dart' as xml;
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:location/location.dart' as loc;

class GymInfoPage extends StatefulWidget {
  final GymTile gym;

  GymInfoPage({Key key, @required this.gym}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new GymInfoPageState(gym);
  }
}

class GymInfoPageState extends State<GymInfoPage> {
  GymInfoPageState(this.tile);
  final GymTile tile;
  // Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  static CameraPosition _kSingapore = CameraPosition(
    target: LatLng(1.3521, 103.8198),
    zoom: 10,
  );
  String kmlContent;
  double latitude;
  double longitude;
  List allTiles = [];
  final Set<Marker> _markers = {};
  @override
  void initState() {
    // _getLocation();
    super.initState();
    // geo.Geolocator()
    //     .getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high)
    //     .then((geo.Position position) {
    //   setState(() {
    //     latitude = position.latitude;
    //     longitude = position.longitude;
    //     print(latitude);
    //     print(longitude);
    //   });
    // });
    loc.Location()
        .getLocation()
        .then((loc.LocationData position) {
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
        print(latitude);
        print(longitude);
      });
    });
  
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(LatLng(tile.latitude, tile.longitude).toString()),
        // markerId: MarkerId(_lastMapPosition.toString()),
        position: LatLng(tile.latitude, tile.longitude),
        infoWindow: InfoWindow(
          title: tile.name,
          snippet: tile.address,
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }
  MapType _currentMapType = MapType.normal;

  LatLng _lastMapPosition = LatLng(1.3521, 103.8198);

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  // _getLocation() async {
  //   var location = new Location();
  //   try {
  //     currentLocation = await location.getLocation();

  //     print("locationLatitude: ${currentLocation["latitude"]}");
  //     print("locationLongitude: ${currentLocation["longitude"]}");
  //     setState(
  //         () {}); //rebuild the widget after getting the current location of the user
  //   } on Exception {
  //     currentLocation = null;
  //   }
  // }

  List androidVersionNames = ["Cupcake", "Donut"];
  @override
  Widget build(BuildContext context) {
    print(tile.description);
    return new Scaffold(
      appBar: AppBar(
          title: Text('Search for Gyms'),
        ),
      body: Column(
        children: <Widget>[
          Container(
            height: 300,
            width: 500,
            child: GoogleMap(
              mapType: _currentMapType,
              initialCameraPosition: _kSingapore,
              myLocationEnabled: true,
              // onMapCreated: (GoogleMapController controller) {
              //   // _controller.complete(controller);
              // },
              onMapCreated: _onMapCreated,
              onCameraMove: _onCameraMove,
              markers: _markers,
            ),
          ),
          Container(
              padding: EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
              child: 
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:Column(
              children: <Widget>[
                Text(tile.name, style: new TextStyle(color: Colors.black, fontSize: 24.0)),
                SizedBox(height: 16.0),
                Text("Distance: " + tile.distance.toString() + "km",
                    style: new TextStyle(color: Colors.black)),
                    SizedBox(height: 16.0),
                Text(tile.description, style: new TextStyle(color: Colors.black)),
              ],
            ),)),
        ],
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _goToTheLake,
      //   label: Text('To the lake!'),
      //   icon: Icon(Icons.directions_boat),
      // ),
    );
  }
}