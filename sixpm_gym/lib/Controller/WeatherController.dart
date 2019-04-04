import 'package:sixpm_gym/Model/Weather.dart';

class WeatherController {
  List<Weather> fromJson(Map<String, dynamic> json) {
    List<Weather> list = new List();
    Weather weather;

    for (int i = 0; i < json['area_metadata'].length; i++) {
      weather = Weather(
        json['area_metadata'][i]['name'],
        json['items'][0]['forecasts'][i]['forecast'],
        json['area_metadata'][i]['label_location']['latitude'],
        json['area_metadata'][i]['label_location']['longitude'],
      );
      list.add(weather);
    }
    return list;
  }
}
