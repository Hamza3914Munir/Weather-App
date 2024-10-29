import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/Activity/Home.dart';
import 'package:weather_app/Activity/Location.dart';
import 'package:weather_app/Provider/WeatherData.dart';

class Loading extends StatefulWidget {
  final String? searchText;

  Loading([this.searchText]);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  Future<void> startApp() async {
    WeatherData weatherData = Provider.of<WeatherData>(context, listen: false);

    if (widget.searchText == null) {
      await _getLocation();
    }
    String city = widget.searchText ?? weatherData.city;
    if (city.isEmpty) {
      Fluttertoast.showToast(
          msg: "Network connection error", toastLength: Toast.LENGTH_LONG);
      return;
    }

    await weatherData.fetchData(city);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Home(),
      ),
    );
  }

  Future<void> _getLocation() async {
    try {
      Location loc = Location();
      await loc.determinePosition();
      Provider.of<WeatherData>(context, listen: false).city =
          loc.currentAddress ?? "Unknown";
    } catch (e) {
      print("Error getting location: $e");
      Provider.of<WeatherData>(context, listen: false).city = "Unknown";
    }
  }

  @override
  void initState() {
    super.initState();
    startApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[300],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 20),
          Image.asset("lib/Assets/app-icon.png"),
          SizedBox(height: 15),
          Text(
            "Weather App",
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(height: 10),
          Text(
            "Made By Hamza Munir",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
          ),
          SizedBox(height: 30),
          SpinKitWave(
            color: Colors.white,
            size: 50.0,
          ),
        ],
      ),
    );
  }
}
