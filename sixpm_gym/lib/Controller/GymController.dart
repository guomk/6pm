import 'package:flutter/services.dart';
import 'package:sixpm_gym/Model/GymTile.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:xml/xml.dart' as xml;

class GymController {
GymTile tile;

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