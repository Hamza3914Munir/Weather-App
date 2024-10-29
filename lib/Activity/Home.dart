import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/Activity/Loading.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:weather_app/Provider/WeatherData.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = TextEditingController();
  FlutterTts flutterTts = FlutterTts();

  String? selectedLanguage;
  List<String> languages = [];
  @override
  void initState() {
    super.initState();
    _getLanguages();
  }

  Future _getLanguages() async {
    languages = (await flutterTts.getLanguages).cast<String>();
    setState(() {}); // Updates the UI after fetching the languages
  }


  void onSearchSubmitted() {
    String searchText = searchController.text.toString();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Loading(searchText),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    WeatherData weatherData = Provider.of<WeatherData>(context);
    Future<void> speakWeatherData() async {
      // await flutterTts.setLanguage(selectedLanguage.isoCode);

      String textToSpeak =
          "The temperature in ${weatherData.city} is ${weatherData.temp} degrees Celsius. "
          "Air speed is ${weatherData.airSpeed} kilometers per hour. "
          "Humidity is ${weatherData.humidity} percent.";

      await flutterTts.speak(textToSpeak);
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0),
        child: AppBar(
          backgroundColor: Colors.blueAccent[800],
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.blueAccent, Colors.indigo],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        margin:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 18),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.white,
                        ),
                        child: TextField(
                          controller: searchController,
                          textInputAction: TextInputAction.search,
                          onSubmitted: (search) {
                            onSearchSubmitted(); // Calling the function without passing any parameters
                          },
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () {
                                onSearchSubmitted();
                              },
                            ),
                            hintText: "  Search Any City ...",
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(5),
                      width: 140,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: Colors.white.withOpacity(0.5), width: 4)),
                      child: Column(
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                speakWeatherData();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.lightBlueAccent),
                              child: Row(
                                children: [
                                  Text("Speak"),
                                  SizedBox(width: 12,),
                                  Icon(Icons.volume_up)
                                ],
                              )),
                          DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              hint: Text('Select Language'),
                              value: selectedLanguage,
                              isExpanded: true,
                              items: languages.map((String language) {
                                return DropdownMenuItem<String>(
                                  value: language,
                                  child: Text(language),
                                );
                              }).toList(),
                              onChanged: (String? newLanguage) {
                                setState(() {
                                  selectedLanguage = newLanguage;
                                  // Set the language in flutter_tts
                                  flutterTts.setLanguage(newLanguage!);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 25),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding:
                            EdgeInsets.only(top: 15, right: 10, bottom: 15),
                        child: Row(
                          children: [
                            Image.network(
                              "https://openweathermap.org/img/wn/${weatherData.icon}@2x.png",
                            ),
                            Column(
                              children: [
                                Text(
                                  weatherData.description,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.location_on),
                                    Text(
                                      weatherData.city,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 240,
                        margin:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: EdgeInsets.all(30),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(WeatherIcons.thermometer),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  weatherData.temp,
                                  style: TextStyle(fontSize: 90),
                                ),
                                Text(
                                  "C",
                                  style: TextStyle(fontSize: 30),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Container(
                        height: 175,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: EdgeInsets.all(30),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(WeatherIcons.day_cloudy_windy),
                              ],
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text("Air speed"),
                            Expanded(
                              child: Text(
                                weatherData.airSpeed,
                                style: TextStyle(
                                    fontSize: 40, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              "Km/h",
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 175,
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: EdgeInsets.all(30),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(WeatherIcons.humidity),
                              ],
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text("Humidity"),
                            Expanded(
                              child: Text(
                                weatherData.humidity,
                                style: TextStyle(
                                    fontSize: 36, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Text(
                              "percent",
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: EdgeInsets.all(5),
                        child: Column(
                          children: [
                            Text(
                              "Made By Hamza Munir",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            Text(
                              "Data Provided By Openweathermap.org",
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
