import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
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
  final FlutterTts flutterTts = FlutterTts();
  late stt.SpeechToText _speech;
  bool _isListening = false;
  bool _isSpeaking = false;
  Offset _dragStart = Offset.zero; // Track the starting position of the swipe

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
    String allOptions = options
        .map((option) => 'say ${option.title} ${option.description}')
        .join('. ');
    await _speak("Options available are: $allOptions");
  }

  Future<void> _stopSpeaking() async {
    await flutterTts.stop();
    _isSpeaking = false;
  }

  Future<void> _startListening() async {
    await _stopSpeaking(); // Stop TTS if it's speaking
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

      // Set a timeout to stop listening if no command is detected
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

  void _handleCommand(String command) {
    command = command.toLowerCase();
    if (command.contains('weather')) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => WeatherPage()));
    } else if (command.contains('battery')) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => BatteryStatus()));
    } else if (command.contains('read')) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ReadPage()));
    } else if (command.contains('object detection')) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ObjectDetectionPage()));
    } else if (command.contains('calculator')) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => CalculatorPage()));
    } else if (command.contains('time') || command.contains('date')) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => TimeAndDatePage()));
    } else if (command.contains('back')) {
      Navigator.pop(context);
    } else if (command.contains('exit')) {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    } else {
      _speak("Sorry, I didn't understand the command.");
    }
  }

  @override
  void initState() {
    super.initState();
    _speakAllOptions();
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
      _speakAllOptions();
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
          _dragStart = details.globalPosition; // Track the starting position
        },
        onHorizontalDragEnd: (details) async {
          final dragEnd = details.velocity.pixelsPerSecond;
          final dragDifference = _dragStart.dx - dragEnd.dx;

          if (dragDifference.abs() > 100) {
            // Check if swipe is primarily horizontal
            if (dragEnd.dy.abs() < dragEnd.dx.abs()) {
              if (dragEnd.dx > 0) { // Right swipe
                if (await Vibration.hasVibrator() ?? false) {
                  Vibration.vibrate(duration: 100);
                }
                _startListening();
              } else { // Left swipe
                _speakAllOptions();
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
                    leading: Image.asset(
                      options[index].iconPath,
                      width: 40,
                      height: 40,
                    ),
                    title: Text(
                      ' ${options[index].title}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    subtitle: Text(options[index].description),
                    onTap: () async {
                      if (await Vibration.hasVibrator() ?? false) {
                        Vibration.vibrate(duration: 100);
                      }
                      await _speak(' ${options[index].title}: ${options[index].description}');
                      switch (options[index].title) {
                        case 'READ':
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ReadPage()));
                          break;
                        case 'OBJECT DETECTION':
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ObjectDetectionPage()));
                          break;
                        case 'CALCULATOR':
                          Navigator.push(context, MaterialPageRoute(builder: (context) => CalculatorPage()));
                          break;
                        case 'WEATHER':
                          Navigator.push(context, MaterialPageRoute(builder: (context) => WeatherPage()));
                          break;
                        case 'BATTERY':
                          Navigator.push(context, MaterialPageRoute(builder: (context) => BatteryStatus()));
                          break;
                        case 'TIME AND DATE':
                          Navigator.push(context, MaterialPageRoute(builder: (context) => TimeAndDatePage()));
                          break;
                      }
                    },
                    onLongPress: () async {
                      if (await Vibration.hasVibrator() ?? false) {
                        Vibration.vibrate(duration: 200);
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Haptic feedback activated for ${options[index].title}')),
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
