import 'package:flutter/material.dart'; // Necessary for UI components
import 'package:flutter/services.dart'; // Import for HapticFeedback
import 'package:vibration/vibration.dart'; // Import for Vibration
import 'ReadPage.dart';
import 'ObjectDetectionPage.dart';
import 'CalculatorPage.dart';
import 'WeatherPage.dart';
import 'NavigationPage.dart';
import 'BatteryStatus.dart';
import 'TimeAndDatePage.dart';
import 'CameraScreen.dart';

class MainPage extends StatelessWidget {
  final List<Option> options = [
    Option('READ', 'Read the text using camera', 'assets/read.png'),
    Option('OBJECT DETECTION', 'Detect the object', 'assets/obj.png'),
    Option('CALCULATOR', 'Perform mathematical calculations', 'assets/cal.png'),
    Option('WEATHER', 'Get weather details', 'assets/weather.png'),
    Option('NAVIGATION', 'Navigate to the destination', 'assets/nav.png'),
    Option('BATTERY', 'Get battery percentage', 'assets/batt.png'),
    Option('TIME AND DATE', 'Get time and date', 'assets/tnd.png'),
    Option('BACK', 'Return to Home screen', 'assets/back.png'),
    Option('EXIT', 'Close the application', 'assets/exit.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Visio-Guide', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: <Widget>[
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/wpg.png"), // Ensure this image is in your assets
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
                  leading: Image.asset(
                    options[index].iconPath, // Load custom icon from assets
                    width: 40, // Adjust the size of the custom icon
                    height: 40,
                  ),
                  title: Text(
                    'Say ${options[index].title}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text(options[index].description),
                  onTap: () async {
                    // Check if device can vibrate
                    if (await Vibration.hasVibrator() ?? false) {
                      // Vibration feedback on tap
                      Vibration.vibrate(duration: 100); // Vibrate for 100 milliseconds
                    }

                    // Navigate to the respective feature page
                    switch (options[index].title) {
                      case 'READ':
                      case 'OBJECT DETECTION':
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CameraScreen()),
                        );
                        break;
                      case 'CALCULATOR':
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CalculatorPage()),
                        );
                        break;
                      case 'WEATHER':
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => WeatherPage()),
                        );
                        break;
                      case 'NAVIGATION':
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => NavigationPage()),
                        );
                        break;
                      case 'BATTERY':
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BatteryStatus()),
                        );
                        break;
                      case 'TIME AND DATE':
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => TimeAndDatePage()),
                        );
                        break;
                    // Handle BACK and EXIT options as needed
                    }
                  },
                  onLongPress: () async {
                    // Check if device can vibrate
                    if (await Vibration.hasVibrator() ?? false) {
                      // Vibration feedback on long press
                      Vibration.vibrate(duration: 200); // Vibrate for 200 milliseconds
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Haptic feedback activated for ${options[index].title}'),
                      ),
                    );
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
  final String iconPath;

  Option(this.title, this.description, this.iconPath);
}