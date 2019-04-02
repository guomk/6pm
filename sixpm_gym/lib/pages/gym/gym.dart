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
import 'gymInfo.dart';

class GymPage extends StatefulWidget {
  final GymStorage storage;

  GymPage({Key key, @required this.storage}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new MapSampleState();
  }
}

class GymStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    print(path);
    return File('$path/counter.txt');
  }

  Future<String> readContent() async {
    // final file = await _localFile;

    // // Read the file
    // String contents = await file.readAsString();
    String content =
        await rootBundle.loadString('assets/EXERCISEFACILITIES.kml');
    print(content.substring(1, 100));
    return content;
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$counter');
  }
}

class MapSampleState extends State<GymPage> {
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
    // getGymTiles().then((List Tiles) {
    //   setState(() {
    //     allTiles = Tiles;
    //     print(allTiles[0].distance);
    //   });
    // });
  }

  // static CameraPosition _kWestgate = CameraPosition(
  //     bearing: 192.8334901395799,
  //     target: LatLng(1.334669, 103.743307),
  //     tilt: 59.440717697143555,
  //     zoom: 20);

  // static CameraPosition _kJunction = CameraPosition(
  //     bearing: 192.8334901395799,
  //     target: LatLng(1.385449, 103.760594),
  //     tilt: 59.440717697143555,
  //     zoom: 20);

  // static CameraPosition _kBishan = CameraPosition(
  //     bearing: 192.8334901395799,
  //     target: LatLng(1.369470, 103.850074),
  //     tilt: 59.440717697143555,
  //     zoom: 20);

  MapType _currentMapType = MapType.normal;

  // void _onMapTypeButtonPressed() {
  //   setState(() {
  //     _currentMapType = _currentMapType == MapType.normal
  //         ? MapType.satellite
  //         : MapType.normal;
  //   });
  // }

  // Future<void> _goToWestgate() async {
  //   // final GoogleMapController controller = await _controller.future;
  //   mapController.animateCamera(CameraUpdate.newCameraPosition(_kWestgate));
  // }

  // Future<void> _goToJunction() async {
  //   // final GoogleMapController controller = await _controller.future;
  //   mapController.animateCamera(CameraUpdate.newCameraPosition(_kJunction));
  // }

  // Future<void> _goToBishan() async {
  //   // final GoogleMapController controller = await _controller.future;
  //   mapController.animateCamera(CameraUpdate.newCameraPosition(_kBishan));
  // }

  final Set<Marker> _markers = {};

  void _onAddMarkerButtonPressed(GymTile tile) {
    setState(() {
      _markers.clear();
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
    ListTile makeListTile(GymTile tile) => ListTile(
          title: Container(
              child: Row(
            children: <Widget>[
              Container(
                width: 200,
                child: Text(tile.name),
              ),
              Container(
                height: 40.0,
                width: 1.0,
                color: Colors.black,
                margin: const EdgeInsets.only(left: 10.0, right: 10.0),
              ),
              Container(
                  width: 100,
                  child: Text(tile.distance.toString().substring(0, 4))
                  // child: Text(latitude.toString()),
                  ),
                IconButton(
            icon: new Icon(Icons.info),
            tooltip: 'Refresh',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => GymInfoPage(gym: tile)));
            },
            color: Colors.black,
          ),
            ],
          )),
          onTap: () {
            _onAddMarkerButtonPressed(tile);
          },
        );

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
              child: Row(
                children: <Widget>[
                  Container(
                    width: 220,
                    child: Text(
                      'Gym Name',
                      style: TextStyle(
                          fontSize: 15.0,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: 150,
                    child: Text(
                      'Distance(km)',
                      style: TextStyle(
                          fontSize: 15.0,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.bold),
                    ),
                    // child: Text(latitude.toString()),
                  )
                ],
              )),
          new Expanded(
              child: new FutureBuilder(
              future: getGymTiles(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data != null) {
                    return ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                        color: Colors.black,
                      ),
                  itemCount: 152,
                  itemBuilder: (context, index) =>
                      makeListTile(snapshot.data[index]));
                  }
                } else {
                  return Center(child: new CircularProgressIndicator());
                }
              }),
              )
        ],
      ),
    );
  }
}

Future<List> getGymTiles() async {
  geo.Position pos = await geo.Geolocator()
      .getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high);
  double latitude = 0;
  double longitude = 0;
  List allgyms = [];
  print(pos.latitude);
  print(pos.longitude);
  print(latitude);
  print(longitude);
  var content = await rootBundle.loadString('assets/EXERCISEFACILITIES.kml');
  var document = xml.parse(content);

  var gymName = document.findAllElements('Placemark');
  List gymNames = [];
  List gymCoordinates = [];
  for (var gym in gymName) {
    gymNames.add(gym.findAllElements('name').single.text);
    allgyms.add(gym.findAllElements('description'));
    gymCoordinates.add(gym
        .findAllElements('Point')
        .single
        .findAllElements('coordinates')
        .single
        .text);
  }
  List gymContents = [];
  for (int i = 0; i < 152; i++) {
    var firstGym = allgyms[i];
    var firstDescription;
    for (var des in firstGym) {
      firstDescription = des;
    }
    var tables = firstDescription
        .findAllElements('body')
        .single
        .findAllElements('table');
    var secondTable;
    for (var table in tables) {
      secondTable = table;
    }
    var trIter = secondTable.findAllElements('tr');
    List tdList = [];
    for (var tr in trIter) {
      var tdIter = tr.findAllElements('td');
      for (var td in tdIter) {
        tdList.add(td);
      }
    }
    print(i);
    List coords = gymCoordinates[i].split(",");
    double dis = await geo.Geolocator().distanceBetween(
        pos.latitude, pos.longitude, double.parse(coords[1]), double.parse(coords[0]));
    String des = tdList[23].text;
    des = des.replaceAll(new RegExp(r'\n\s*\n'), '\n\n');
    des = des.replaceAll('?', 'to');
    des = des.trim();
    if(des[des.length - 1] == 'T'){
      des = des.substring(0, des.length - 1);
    }
    var result = GymTile(
      name: gymNames[i],
      postalCode: tdList[7].text,
      address: tdList[19].text,
      description: des,
      latitude: double.parse(coords[1]),
      longitude: double.parse(coords[0]),
      distance: dis / 1000,
    );
    gymContents.add(result);
  }
  gymContents.sort((a, b) => a.distance.compareTo(b.distance));
  return gymContents;
}
