import 'package:flutter/material.dart'; // Necessary for UI components
import 'package:flutter/services.dart'; // Import for HapticFeedback
import 'package:vibration/vibration.dart'; // Import for Vibration
import 'package:flutter_tts/flutter_tts.dart'; // Import for TTS
import 'package:speech_to_text/speech_to_text.dart' as stt; // Import for speech recognition
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

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  final FlutterTts flutterTts = FlutterTts(); // TTS instance
  late stt.SpeechToText _speech; // SpeechToText instance
  bool _isListening = false;
  bool _isSpeaking = false; // Track if TTS is currently speaking

  final List<Option> options = [
    Option('READ', 'to read text using the camera', 'assets/read.png'),
    Option('OBJECT DETECTION', 'to detect an object', 'assets/obj.png'),
    Option('CALCULATOR', 'to perform math calculations.', 'assets/cal.png'),
    Option('WEATHER', 'to get weather details', 'assets/weather.png'),
    Option('BATTERY', 'to check battery percentage', 'assets/batt.png'),
    Option('TIME AND DATE', 'to check the current time and date', 'assets/tnd.png'),
    Option('BACK', 'return to the home screen', 'assets/back.png'),
    Option('EXIT', 'to close the application', 'assets/exit.png'),
  ];

  // Function to speak the selected option with description
  Future<void> _speak(String text) async {
    _isSpeaking = true; // Set speaking state to true
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.4); // Slower speech rate
    await flutterTts.speak(text);
    flutterTts.setCompletionHandler(() {
      _isSpeaking = false; // Set speaking state to false when done
    });
  }

  // Automatically read all options with description when the page opens
  Future<void> _speakAllOptions() async {
    String allOptions = options
        .map((option) => 'Say ${option.title} ${option.description}')
        .join('. ');
    await _speak("Options available are: $allOptions");
  }

  Future<void> _startListening() async {
    _speech = stt.SpeechToText(); // Initialize SpeechToText object
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(onResult: (result) {
        // Check for recognized command
        _handleCommand(result.recognizedWords);
      });
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  // Handle the recognized command
  void _handleCommand(String command) {
    // Check specific commands and take action
    if (command.toLowerCase().contains('weather')) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => WeatherPage()));
    } else if (command.toLowerCase().contains('battery')) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => BatteryStatus()));
    } else if (command.toLowerCase().contains('read')) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => CameraScreen()));
    } else if (command.toLowerCase().contains('object detection')) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => CameraScreen()));
    } else if (command.toLowerCase().contains('calculator')) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => CalculatorPage()));
    } else if (command.toLowerCase().contains('time and date')) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => TimeAndDatePage()));
    } else if (command.toLowerCase().contains('back')) {
      Navigator.pop(context); // Go back to the previous page
    } else if (command.toLowerCase().contains('exit')) {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop'); // Close the app
    }
  }

  @override
  void initState() {
    super.initState();
    _speakAllOptions(); // Automatically speak all the options with description on page load
    WidgetsBinding.instance.addObserver(this); // Add observer for app lifecycle
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Remove observer
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _speakAllOptions(); // Speak options when returning to the app
    }
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
          // Detect right swipe
          if (details.velocity.pixelsPerSecond.dx > 0) {
            _speak("Voice command activated"); // Speak the activation message
            _startListening(); // Activate voice command on right swipe
          }

          // Detect left swipe
          else if (details.velocity.pixelsPerSecond.dx < 0) {
            _speakAllOptions(); // Speak options on left swipe
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

                      // Navigate to the respective feature page based on the title
                      switch (options[index].title) {
                        case 'READ':
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CameraScreen()),
                          );
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
