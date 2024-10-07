import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'WeatherService.dart'; // Import your WeatherService

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  WeatherService weatherService = WeatherService();
  String temperature = '';
  String weatherDescription = '';
  String locationName = '';

  @override
  void initState() {
    super.initState();
    getWeatherData();
  }

  Future<void> getWeatherData() async {
    try {
      // Get user's current location
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Fetch weather data
      var weatherData = await weatherService.getWeather(
          position.latitude, position.longitude);

      setState(() {
        temperature = weatherData['current']['temp_c'].toString();
        weatherDescription = weatherData['current']['condition']['text'];
        locationName = weatherData['location']['name']; // Get the location name
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/wpg.png'), // Use your asset image here
            fit: BoxFit.cover, // Cover the entire screen
          ),
        ),
        child: Center(
          child: temperature.isNotEmpty
              ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Location: $locationName',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              Text(
                'Temperature: $temperature °C',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              Text(
                'Condition: $weatherDescription',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ],
          )
              : CircularProgressIndicator(),
        ),
      ),
    );
  }
}
