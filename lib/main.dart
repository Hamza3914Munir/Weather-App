import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/Activity/Loading.dart';
import 'package:weather_app/Provider/WeatherData.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => WeatherData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Loading(),
      ),
    ),
  );
}
