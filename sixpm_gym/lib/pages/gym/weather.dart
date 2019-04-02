import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import './gym.dart';

class WeatherPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new WeatherPageState();
  }
}

class WeatherPageState extends State<WeatherPage> {
  GoogleMapController mapController;
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  static CameraPosition _kSingapore = CameraPosition(
    target: LatLng(1.3521, 103.8198),
    zoom: 10,
  );

  final Set<Marker> _markers = {};

  MapType _currentMapType = MapType.normal;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Container(
          height: 250,
          width: 500,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: 16.0),
                Text('Singapore', style: new TextStyle(color: Colors.black)),
                SizedBox(height: 16.0),
                Text('Sunny',
                    style: new TextStyle(color: Colors.black, fontSize: 32.0)),
                    SizedBox(height: 16.0),
                Text('29°C', style: new TextStyle(color: Colors.black)),
                Image.network('https://openweathermap.org/img/w/01d.png'),
                Text('April 3, 2019', style: new TextStyle(color: Colors.black)),
              ],
            ),
          )),
      Stack(children: <Widget>[
        Container(
          height: 295,
          width: 500,
          child: GoogleMap(
            mapType: _currentMapType,
            initialCameraPosition: _kSingapore,
            myLocationEnabled: true,
            // onMapCreated: (GoogleMapController controller) {
            //   // _controller.complete(controller);
            // },
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
              Navigator.of(context).pushNamed('/gympage');
            },
            color: Colors.black,
          ),
        )
      ])
    ])));
  }
}