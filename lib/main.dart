import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Activity/Loading.dart';
import 'Provider/WeatherData.dart';



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
