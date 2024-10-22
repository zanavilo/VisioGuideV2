import 'package:flutter/material.dart'; // Necessary for UI components
import 'package:flutter/services.dart'; // Import for HapticFeedback
import 'package:vibration/vibration.dart'; // Import for Vibration
import 'package:flutter_tts/flutter_tts.dart'; // Import for TTS
import 'ReadPage.dart';
import 'ObjectDetectionPage.dart';
import 'CalculatorPage.dart';
import 'WeatherPage.dart';
import 'BatteryStatus.dart';
import 'TimeAndDatePage.dart';
import 'CameraScreen.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final FlutterTts flutterTts = FlutterTts(); // TTS instance

  final List<Option> options = [
    Option('READ', 'to read text using the camera', 'assets/read.png'),
    Option('OBJECT DETECTION', 'to detect an object', 'assets/obj.png'),
    Option('CALCULATOR', 'to perform math calculations', 'assets/cal.png'),
    Option('WEATHER', 'to get weather details', 'assets/weather.png'),
    Option('BATTERY', 'to check battery percentage', 'assets/batt.png'),
    Option('TIME AND DATE', 'to check the current time and date', 'assets/tnd.png'),
    Option('BACK', 'return to the home screen', 'assets/back.png'),
    Option('EXIT', 'to close the application', 'assets/exit.png'),
  ];

  // Function to speak the selected option with description
  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.4); // Slower speech rate
    await flutterTts.speak(text);
  }

  // Automatically read all options with description when the page opens
  Future<void> _speakAllOptions() async {
    String allOptions = options
        .map((option) => 'Say ${option.title} ${option.description}')
        .join('. ');
    await _speak("Options available are: $allOptions");
  }

  // Function to speak the title and description of all options
  Future<void> _speakAllTitlesAndDescriptions() async {
    for (var option in options) {
      await _speak('${option.title} - ${option.description}');
      // Wait a bit before speaking the next option (optional)
      await Future.delayed(Duration(milliseconds: 3500)); // Adjust delay as needed
    }
  }

  @override
  void initState() {
    super.initState();
    _speakAllOptions(); // Automatically speak all the options with description on page load
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Visio-Guide', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          // Detect left swipe
          if (details.velocity.pixelsPerSecond.dx < 0) {
            _speakAllTitlesAndDescriptions(); // Speak all titles and descriptions on left swipe
          }
        },
        child: Stack(
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

                      // Speak the selected option and description
                      await _speak('Say ${options[index].title}: ${options[index].description}');

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
