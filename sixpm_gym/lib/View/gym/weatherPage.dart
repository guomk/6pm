import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sixpm_gym/Model/Weather.dart';
import 'package:sixpm_gym/Controller/WeatherController.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart' as loc;
import 'package:geolocator/geolocator.dart' as geo;

class WeatherPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new WeatherPageState();
  }
}

class WeatherPageState extends State<WeatherPage> {
  GoogleMapController mapController;
  List<Weather> weatherList = new List();
  double latitude, longitude;
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    loc.Location().getLocation().then((loc.LocationData position) {
      setState(() {
        latitude = position.latitude;
        longitude = position.longitude;
      });
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  final Set<Marker> _markers = {};

  MapType _currentMapType = MapType.normal;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Center(
            child: new FutureBuilder(
                future: fetchWeather(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data != null) {
                      weatherList = snapshot.data;

                      return FutureBuilder(
                          future: getNearestWeather(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              if (snapshot.data != null) {
                                _markers.add(Marker(
                                  // This marker id can be anything that uniquely identifies each marker.
                                  markerId: MarkerId('1'),
                                  position: LatLng(snapshot.data.latitude,
                                      snapshot.data.longitude),
                                  infoWindow: InfoWindow(
                                    title: snapshot.data.name,
                                    snippet: snapshot.data.forecast,
                                  ),
                                  icon: BitmapDescriptor.defaultMarkerWithHue(
                                      BitmapDescriptor.hueBlue),
                                ));
                                return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Container(
                                          height: 250,
                                          width: 500,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: new Column(
                                              children: <Widget>[
                                                SizedBox(height: 16.0),
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Icon(Icons.location_on),
                                                      Text(snapshot.data.name,
                                                          style: new TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 28.0)),
                                                    ]),
                                                SizedBox(height: 16.0),
                                                Text(snapshot.data.forecast,
                                                    style: new TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 32.0)),
                                                SizedBox(height: 16.0),
                                                Text(
                                                    now.day.toString() +
                                                        '/' +
                                                        now.month.toString() +
                                                        '/' +
                                                        now.year.toString(),
                                                    style: new TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 28.0)),
                                              ],
                                            ),
                                          )),
                                      Stack(children: <Widget>[
                                        Container(
                                          height: 295,
                                          width: 500,
                                          child: GoogleMap(
                                            mapType: _currentMapType,
                                            initialCameraPosition:
                                                CameraPosition(
                                              target: LatLng(1.3521, 103.8198),
                                              zoom: 10,
                                            ),
                                            myLocationEnabled: true,
                                            onMapCreated: _onMapCreated,
                                            markers: _markers,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: IconButton(
                                            icon: new Icon(Icons.search),
                                            tooltip: 'Refresh',
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pushNamed('/gympage');
                                            },
                                            color: Colors.black,
                                          ),
                                        )
                                      ]),
                                    ]);
                              }
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          });
                    }
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                })));
  }

  Future<List<Weather>> fetchWeather() async {
    final response = await http
        .get('https://api.data.gov.sg/v1/environment/2-hour-weather-forecast');

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON
      return WeatherController().fromJson(json.decode(response.body));
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<Weather> getNearestWeather() async {
    //Calculate nearest weather marker to current location
    double shortestDist = 1000000, dist;
    Weather shortestWeather;
    for (int i = 0; i < weatherList.length; i++) {
      dist = await geo.Geolocator().distanceBetween(latitude, longitude,
          weatherList[i].latitude, weatherList[i].longitude);
      if (dist < shortestDist) {
        shortestDist = dist;
        shortestWeather = weatherList[i];
      }
    }
    return shortestWeather;
  }
}
