import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'GymTile.dart';
import 'package:xml/xml.dart' as xml;
import 'dart:io';
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
    return File('$path/counter.txt');
  }

  Future<String> readContent() async {
    // // Read the file
    String content =
        await rootBundle.loadString('assets/EXERCISEFACILITIES.kml');
    return content;
  }

  Future<File> writeCounter(int counter) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$counter');
  }
}

class MapSampleState extends State<GymPage> {
  GoogleMapController mapController;
  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  List _gymNames = new List();
  List _filteredNames = new List();
  List<GymTile> allTiles = new List();
  List<GymTile> filteredTiles = new List();
  Icon _searchIcon = new Icon(Icons.search);
  Widget _appBarTitle = new Text('Search for gyms');

  String kmlContent;
  double latitude;
  double longitude;
  MapType _currentMapType = MapType.normal;
  final Set<Marker> _markers = {};

  MapSampleState() {
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          _filteredNames = _gymNames;
        });
      } else {
        setState(() {
          _searchText = _filter.text;
        });
      }
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  static CameraPosition _kSingapore = CameraPosition(
    target: LatLng(1.3521, 103.8198),
    zoom: 10,
  );

  void _onAddMarkerButtonPressed(GymTile tile) {
    setState(() {
      _markers.clear();
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
        markerId: MarkerId(LatLng(tile.latitude, tile.longitude).toString()),
        position: LatLng(tile.latitude, tile.longitude),
        infoWindow: InfoWindow(
          title: tile.name,
          snippet: tile.address,
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
      title: _appBarTitle,
      leading: new IconButton(
        icon: _searchIcon,
        onPressed: _searchPressed,
      ),
    );
  }

  void _searchPressed() {
    setState(() {
      if (this._searchIcon.icon == Icons.search) {
        this._searchIcon = new Icon(Icons.close);
        this._appBarTitle = new TextField(
          controller: _filter,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search), hintText: 'Search for a gym'),
        );
      } else {
        this._searchIcon = new Icon(Icons.search);
        this._appBarTitle = new Text('Search for gyms');
        _filteredNames = _gymNames;
        _filter.clear();
      }
    });
  }

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
                child: Text(tile.distance.toString().substring(0, 4))),
            IconButton(
              icon: new Icon(Icons.info),
              tooltip: 'More Info',
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GymInfoPage(gym: tile)));
              },
              color: Colors.black,
            ),
          ],
        )),
        onTap: () {
          _onAddMarkerButtonPressed(tile);
        },
      );

  Widget _buildList() {
    if (!(_searchText.isEmpty)) {
      List<GymTile> tempList = new List();
      for (int i = 0; i < _gymNames.length; i++) {
        if (allTiles[i]
            .name
            .toLowerCase()
            .contains(_searchText.toLowerCase())) {
          tempList.add(allTiles[i]);
        }
      }
      filteredTiles = tempList;
      return ListView.separated(
          separatorBuilder: (context, index) => Divider(
                color: Colors.black,
              ),
          itemCount: filteredTiles.length,
          itemBuilder: (context, index) => makeListTile(filteredTiles[index]));
    } else {
      return new FutureBuilder(
          future: getGymTiles(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data != null) {
                return ListView.separated(
                    separatorBuilder: (context, index) => Divider(
                          color: Colors.black,
                        ),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) =>
                        makeListTile(snapshot.data[index]));
              }
            } else {
              return Center(child: new CircularProgressIndicator());
            }
          });
    }
  }

  @override
  void initState() {
    super.initState();
    loc.Location().getLocation().then((loc.LocationData position) {
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
    });
    getGymTiles().then((tileList) {
      allTiles = tileList;
      for (int i = 0; i < tileList.length; i++) {
        _gymNames.add(tileList[i].name);
      }
    });
  }

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _buildBar(context),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          Container(
            height: 300,
            width: 500,
            child: GoogleMap(
              mapType: _currentMapType,
              initialCameraPosition: _kSingapore,
              myLocationEnabled: true,
              onMapCreated: _onMapCreated,
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
                  )
                ],
              )),
          new Expanded(
            child: _buildList(),
          )
        ],
      ),
    );
  }

  Future<List<GymTile>> getGymTiles() async {
    geo.Position pos = await geo.Geolocator()
        .getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high);
    List allgyms = [];
    List<GymTile> gymContents = [];
    List gymNames = [];
    var content = await rootBundle.loadString('assets/EXERCISEFACILITIES.kml');
    var document = xml.parse(content);

    var gymName = document.findAllElements('Placemark');
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
      List coords = gymCoordinates[i].split(",");
      double dis = await geo.Geolocator().distanceBetween(pos.latitude,
          pos.longitude, double.parse(coords[1]), double.parse(coords[0]));
      String des = tdList[23].text;
      des = des.replaceAll(new RegExp(r'\n\s*\n'), '\n\n');
      des = des.replaceAll('?', 'to');
      des = des.trim();
      if (des[des.length - 1] == 'T') {
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
}
