import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'WeatherService.dart'; // Import your weather service

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  WeatherService weatherService = WeatherService();
  String temperature = '';
  String weatherDescription = '';

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
      var weatherData =
      await weatherService.getWeather(position.latitude, position.longitude);

      setState(() {
        temperature = weatherData['current']['temp_c'].toString();
        weatherDescription = weatherData['current']['condition']['text'];
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Details'),
      ),
      body: Center(
        child: temperature.isNotEmpty
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Temperature: $temperature °C',
                style: TextStyle(fontSize: 24)),
            Text('Condition: $weatherDescription',
                style: TextStyle(fontSize: 18)),
          ],
        )
            : CircularProgressIndicator(),
      ),
    );
  }
}
