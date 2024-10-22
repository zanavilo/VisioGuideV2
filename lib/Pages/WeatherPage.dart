import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'WeatherService.dart'; // Import your WeatherService
import 'package:flutter_tts/flutter_tts.dart'; // Import TTS package

class WeatherPage extends StatefulWidget {
  @override
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  WeatherService weatherService = WeatherService();
  final FlutterTts flutterTts = FlutterTts(); // TTS instance
  String temperature = '';
  String weatherDescription = '';
  String locationName = '';
  String humidity = '';
  String precipitation = '';
  String windSpeed = '';
  String windDirection = '';
  String cloudCover = '';
  String visibility = '';
  String visibilityCondition = ''; // Added visibility condition

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
        locationName = weatherData['location']['name'];
        humidity = weatherData['current']['humidity'].toString();
        precipitation = weatherData['current']['precip_mm'].toString();
        windSpeed = weatherData['current']['wind_kph'].toString();
        windDirection = weatherData['current']['wind_dir'];
        cloudCover = weatherData['current']['cloud'].toString();
        visibility = weatherData['current']['vis_km'].toString();
        visibilityCondition = _getVisibilityCondition(double.parse(visibility)); // Determine visibility condition
      });

      await _speakWeatherInfo(); // Speak weather information
    } catch (e) {
      print(e);
    }
  }

  String _getVisibilityCondition(double visibility) {
    if (visibility >= 10) {
      return 'Clear Visibility';
    } else if (visibility >= 5) {
      return 'Moderate Visibility';
    } else if (visibility >= 2) {
      return 'Low Visibility';
    } else {
      return 'Very Low Visibility';
    }
  }

  Future<void> _speakWeatherInfo() async {
    String weatherInfo = 'The current weather in $locationName is $temperature degrees Celsius with $weatherDescription. '
        'Humidity is at $humidity percent, precipitation is $precipitation millimeters, wind speed is $windSpeed kilometers per hour, '
        'wind direction is $windDirection, cloud cover is $cloudCover percent, and visibility is $visibility kilometers, which is considered $visibilityCondition.';

    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5); // Adjust speech rate as needed
    await flutterTts.speak(weatherInfo);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        // Detect right swipe
        if (details.velocity.pixelsPerSecond.dx > 0) {
          _speakReturnMessage(); // Speak return message before going back
          Navigator.pop(context); // Navigate back to MainPage
        }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/wpg.png'), // Use your asset image here
              fit: BoxFit.cover, // Cover the entire screen
            ),
          ),
          child: Center(
            child: temperature.isNotEmpty
                ? SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Location: $locationName',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Temperature: $temperature °C',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Condition: $weatherDescription',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                      textAlign: TextAlign.center, // Center align the condition text
                    ),
                    SizedBox(height: 20), // Spacing between sections
                    _buildWeatherCard('Humidity', '$humidity %', Icons.opacity),
                    _buildWeatherCard('Precipitation', '$precipitation mm', Icons.cloud),
                    _buildWeatherCard('Wind Speed', '$windSpeed kph', Icons.air),
                    _buildWeatherCard('Wind Direction', windDirection, Icons.navigation),
                    _buildWeatherCard('Cloud Cover', '$cloudCover %', Icons.cloud_circle),
                    _buildWeatherCard('Visibility', '$visibility km ($visibilityCondition)', Icons.visibility), // Show visibility condition
                  ],
                ),
              ),
            )
                : CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  Future<void> _speakReturnMessage() async {
    String returnMessage = 'You are at the main page. Swipe left to read all the options.';
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5); // Adjust speech rate as needed
    await flutterTts.speak(returnMessage);
  }

  Widget _buildWeatherCard(String title, String value, IconData icon) {
    return Card(
      elevation: 4,
      color: Colors.blue[300]?.withOpacity(0.5), // Adjust opacity here (0.0 to 1.0)
      margin: EdgeInsets.symmetric(vertical: 5), // Reduced margin for compactness
      child: Padding(
        padding: const EdgeInsets.all(12.0), // Reduced padding for compactness
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24), // Reduced icon size
            SizedBox(width: 8), // Reduced space between icon and text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  Text(
                    value,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
