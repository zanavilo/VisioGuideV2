import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:flutter_tts/flutter_tts.dart'; // Import TTS package

class TimeAndDatePage extends StatefulWidget {
  @override
  _TimeAndDatePageState createState() => _TimeAndDatePageState();
}

class _TimeAndDatePageState extends State<TimeAndDatePage> {
  late String formattedDate;
  final FlutterTts flutterTts = FlutterTts(); // TTS instance

  @override
  void initState() {
    super.initState();
    _updateTime();
    Timer.periodic(Duration(seconds: 12), (Timer t) => _updateTime());
  }

  void _updateTime() async {
    DateTime now = DateTime.now();
    setState(() {
      // Change to a format with month in words
      formattedDate = DateFormat('yyyy MMM dd – hh:mm a').format(now);
    });
    await _speakTime(formattedDate); // Speak the current time
  }

  Future<void> _speakTime(String time) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5); // Adjust speech rate as needed
    await flutterTts.speak('Current time is $time');
  }

  // Speak return message when navigating back
  Future<void> _speakReturnMessage() async {
    String returnMessage = 'You are at the main page. Swipe left to read all the options.';
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(returnMessage);
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
              image: AssetImage('assets/wpg.png'), // Background image
              fit: BoxFit.cover, // Cover the entire screen
            ),
          ),
          child: Center(
            child: Container(
              padding: EdgeInsets.all(16.0), // Padding inside the container
              decoration: BoxDecoration(
                color: Colors.white, // White background
                borderRadius: BorderRadius.circular(20), // 20px border radius
              ),
              child: Text(
                formattedDate,
                style: TextStyle(fontSize: 24, color: Colors.black), // Change text color for visibility
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: TimeAndDatePage(),
  ));
}
