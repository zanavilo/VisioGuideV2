import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'ReadPage.dart';
import 'ObjectDetectionPage.dart';
import 'CalculatorPage.dart';
import 'WeatherPage.dart';
import 'BatteryStatus.dart';
import 'TimeAndDatePage.dart';
import 'EmergencyCallPage.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  final FlutterTts flutterTts = FlutterTts();
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _isSpeaking = false;
  Offset _dragStart = Offset.zero;
  String? _savedPhoneNumber;
  bool _isOnMainPage = true; // Track if we are on MainPage

  final List<Option> options = [
    Option('READ', 'to read text using the camera', 'assets/read.png'),
    Option('OBJECT DETECTION', 'to detect an object', 'assets/obj.png'),
    Option('CALCULATOR', 'to perform math calculations.', 'assets/cal.png'),
    Option('WEATHER', 'to get weather details', 'assets/weather.png'),
    Option('BATTERY', 'to check battery percentage', 'assets/batt.png'),
    Option('TIME AND DATE', 'to check the current time and date', 'assets/tnd.png'),
    Option('EMERGENCY CALL', 'to call someone immediately', 'assets/emergency-call.png'),
    Option('EXIT', 'to close the application', 'assets/exit.png'),
    Option('SWIPE LEFT', 'to read all the options', 'assets/back.png'),
    Option('SWIPE RIGHT', 'to activate the voice command', 'assets/back.png'),
  ];

  Future<void> _speak(String text) async {
    _isSpeaking = true;
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.4);
    await flutterTts.speak(text);
    flutterTts.setCompletionHandler(() {
      _isSpeaking = false;
    });
  }

  Future<void> _speakAllOptions() async {
    String optionsText = options.where((option) => option.title != 'SWIPE LEFT' && option.title != 'SWIPE RIGHT').map((option) {
      return "Say ${option.title}. ${option.description}";
    }).join('. ');

    String swipeLeftText = "Swipe Left to read all options.";
    String swipeRightText = "Swipe Right to activate voice command.";

    await _speak("Here are the options: $optionsText. $swipeLeftText. $swipeRightText.");
  }

  Future<void> _stopSpeaking() async {
    await flutterTts.stop();
    _isSpeaking = false;
  }

  Future<void> _startListening() async {
    await _stopSpeaking();
    _speech = stt.SpeechToText();
    bool available = await _speech.initialize();
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          if (result.finalResult) {
            _handleCommand(result.recognizedWords);
            _stopListening();
          }
        },
      );

      Timer(Duration(seconds: 5), () {
        if (_isListening) {
          _stopListening();
        }
      });
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  Future<void> _loadSavedPhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedPhoneNumber = prefs.getString('savedPhoneNumber');
    });
  }

  void _handleCommand(String command) async {
    command = command.toLowerCase();
    if (command.contains('weather')) {
      _navigateToPage(WeatherPage());
    } else if (command.contains('battery')) {
      _navigateToPage(BatteryStatus());
    } else if (command.contains('emergency call')) {
      _navigateToPage(EmergencyCallPage());
    } else if (command.contains('read')) {
      _navigateToPage(ReadPage());
    } else if (command.contains('object detection')) {
      _navigateToPage(ObjectDetectionPage());
    } else if (command.contains('calculator')) {
      _navigateToPage(CalculatorPage());
    } else if (command.contains('time') || command.contains('date')) {
      _navigateToPage(TimeAndDatePage());
    } else if (command.contains('exit')) {
      await _speak("The application is about to close."); // Speak before closing
      Future.delayed(Duration(seconds: 4), () {
        SystemChannels.platform.invokeMethod('SystemNavigator.pop'); // Close the app
      });
    } else {
      _speak("Sorry, I didn't understand the command.");
    }
  }

  void _navigateToPage(Widget page) {
    setState(() {
      _isOnMainPage = false; // We are navigating away from MainPage
    });
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return page;
    })).then((_) {
      setState(() {
        _isOnMainPage = true; // We are back on MainPage
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _speakAllOptions();
    _loadSavedPhoneNumber();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_isOnMainPage) {
        _speakAllOptions();
      }
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
        onHorizontalDragStart: (details) {
          _dragStart = details.globalPosition;
        },
        onHorizontalDragEnd: (details) async {
          final dragEnd = details.velocity.pixelsPerSecond;
          final dragDifference = _dragStart.dx - dragEnd.dx;

          if (dragDifference.abs() > 100) {
            if (dragEnd.dy.abs() < dragEnd.dx.abs()) {
              if (dragEnd.dx < 0) { // Left swipe
                _speakAllOptions(); // Speak all options
              } else { // Right swipe
                if (await Vibration.hasVibrator() ?? false) {
                  Vibration.vibrate(duration: 100);
                }
                _startListening(); // Start listening for voice commands
              }
            }
          }
        },
        child: Stack(
          children: <Widget>[
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/wpg.png"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            ListView.builder(
              itemCount: options.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    leading: options[index].title == 'SWIPE RIGHT'
                        ? Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(3.14159),
                      child: Image.asset(
                        options[index].iconPath,
                        width: 40,
                        height: 40,
                      ),
                    )
                        : Image.asset(
                      options[index].iconPath,
                      width: 40,
                      height: 40,
                    ),
                    title: Text(
                      options[index].title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(options[index].description),
                    onTap: () async {
                      if (options[index].title == 'READ') {
                        _navigateToPage(ReadPage());
                      } else if (options[index].title == 'OBJECT DETECTION') {
                        _navigateToPage(ObjectDetectionPage());
                      } else if (options[index].title == 'EMERGENCY CALL') {
                        _navigateToPage(EmergencyCallPage());
                      } else if (options[index].title == 'CALCULATOR') {
                        _navigateToPage(CalculatorPage());
                      } else if (options[index].title == 'WEATHER') {
                        _navigateToPage(WeatherPage());
                      } else if (options[index].title == 'BATTERY') {
                        _navigateToPage(BatteryStatus());
                      } else if (options[index].title == 'TIME AND DATE') {
                        _navigateToPage(TimeAndDatePage());
                      } else if (options[index].title == 'EXIT') {
                        await _speak("The application is about to close.");
                        Future.delayed(Duration(seconds: 2), () {
                          SystemChannels.platform.invokeMethod('SystemNavigator.pop'); // Close the app
                        });
                      }
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
