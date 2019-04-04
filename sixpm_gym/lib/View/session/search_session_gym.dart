import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sixpm_gym/Model/GymTile.dart';
import 'dart:async';
import 'package:sixpm_gym/Controller/GymController.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:location/location.dart' as loc;
import '../gym/gymInfo.dart';

class SearchSession extends StatefulWidget {
  final GymStorage storage;

  SearchSession({Key key, @required this.storage}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new SearchSessionState();
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

class SearchSessionState extends State<SearchSession> {
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

  SearchSessionState() {
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
                width: 50,
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
            IconButton(
              icon: new Icon(Icons.check_circle),
              tooltip: 'Select',
              onPressed: () {
                Navigator.pop(context, tile.name);
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
      return FutureBuilder(
          future: GymController().getGymTiles(),
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
              return Center(child: CircularProgressIndicator());
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
    GymController().getGymTiles().then((tileList) {
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
              initialCameraPosition: CameraPosition(
                target: LatLng(1.3521, 103.8198),
                zoom: 10,
              ),
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
}
