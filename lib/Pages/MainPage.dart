import 'package:flutter/material.dart' show AppBar, AssetImage, BoxDecoration, BoxFit, BuildContext, Card, Colors, Container, DecorationImage, EdgeInsets, FontWeight, Icon, IconData, Icons, ListTile, ListView, MaterialPageRoute, Navigator, Scaffold, Stack, StatelessWidget, Text, TextStyle, Widget;
import 'ReadPage.dart';
import 'ObjectDetectionPage.dart';
import 'CalculatorPage.dart';
import 'WeatherPage.dart';
import 'NavigationPage.dart';
import 'BatteryPage.dart';
import 'TimeAndDatePage.dart';

class MainPage extends StatelessWidget { // Extend StatelessWidget directly
  final List<Option> options = [
    Option('READ', 'Read the text using camera', Icons.book),
    Option('OBJECT DETECTION', 'Detect the object', Icons.search),
    Option('CALCULATOR', 'Perform mathematical calculations', Icons.calculate),
    Option('WEATHER', 'Get weather details', Icons.wb_sunny),
    Option('NAVIGATION', 'Navigate to the destination', Icons.navigation),
    Option('BATTERY', 'Get battery percentage', Icons.battery_std),
    Option('TIME AND DATE', 'Get time and date', Icons.access_time),
    Option('BACK', 'Return to Home screen', Icons.arrow_back),
    Option('EXIT', 'Close the application', Icons.exit_to_app),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visio-Guide', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: <Widget>[
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/bbg.png"), // Ensure this image is in your assets
                fit: BoxFit.cover,
              ),
            ),
          ),
          // ListView with options
          ListView.builder(
            itemCount: options.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: Icon(options[index].icon, size: 40),
                  title: Text(
                    'Say ${options[index].title}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text(options[index].description),
                  onTap: () {
                    // Navigate to the respective feature page
                    if (options[index].title == 'READ') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ReadPage()),
                      );
                    } else if (options[index].title == 'OBJECT DETECTION') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ObjectDetectionPage()),
                      );
                    } else if (options[index].title == 'CALCULATOR') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CalculatorPage()),
                      );
                    } else if (options[index].title == 'WEATHER') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => WeatherPage()),
                      );
                    } else if (options[index].title == 'NAVIGATION') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NavigationPage()),
                      );
                    } else if (options[index].title == 'BATTERY') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BatteryPage()),
                      );
                    } else if (options[index].title == 'TIME AND DATE') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TimeAndDatePage()),
                      );
                    }
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class Option {
  final String title;
  final String description;
  final IconData icon;

  Option(this.title, this.description, this.icon);
}
