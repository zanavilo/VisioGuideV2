import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = '7765200b09f34483bee84624240710'; // Replace with your actual API key

  Future<Map<String, dynamic>> getWeather(double lat, double lon) async {
    final String url =
        'http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$lat,$lon&aqi=no';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
