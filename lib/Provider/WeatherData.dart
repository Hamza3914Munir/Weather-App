import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'dart:convert';

class WeatherData extends ChangeNotifier {
  String temp = "";
  String humidity = "";
  String airSpeed = "";
  String description = "";
  String main = "";
  String icon = "";
  String city = "";

  Future<void> fetchData(String location) async {
    try {
      Response response = await get(Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?q=$location&appid=fa4269f11863ca0d600af0af6db58a02"));
      Map data = jsonDecode(response.body);

      Map tempData = data["main"];
      humidity = tempData["humidity"].toString();
      double getTemp = tempData["temp"] - 273.15;
      temp = getTemp.toStringAsFixed(2);

      Map wind = data["wind"];
      double getAirSpeed = wind["speed"] * 3.6; // convert from m/s to km/h
      airSpeed = getAirSpeed.toStringAsFixed(2);

      List weatherData = data["weather"];
      Map weatherMainData = weatherData[0];
      main = weatherMainData["main"];
      description = weatherMainData["description"];
      icon = weatherMainData["icon"];
      city = data["name"];

      notifyListeners();
    } catch (e) {
      temp = "0.0";
      humidity = "0";
      airSpeed = "o.o";
      description = "No Data Found";
      main = "Can't Find Data";
      icon = "50n";
      city = "Unknown";
      notifyListeners();
    }
  }
}
