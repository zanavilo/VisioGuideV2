import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_fonts/google_fonts.dart';

class TimeAndDatePage extends StatefulWidget {
  @override
  _TimeAndDatePageState createState() => _TimeAndDatePageState();
}

class _TimeAndDatePageState extends State<TimeAndDatePage> {
  late String formattedDate;
  final FlutterTts flutterTts = FlutterTts();
  DateTime currentTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _updateTime();
  }

  void _updateTime() async {
    DateTime now = DateTime.now();
    setState(() {
      currentTime = now;
      formattedDate = DateFormat('yyyy MMM dd – hh:mm a').format(now);
    });
    await _speakTime(formattedDate);
  }

  Future<void> _speakTime(String time) async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak('Current time is $time');
  }

  Future<void> _speakReturnMessage() async {
    String returnMessage = 'You are at the main page. Swipe left to read all the options.';
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(returnMessage);
  }

  double getHourRotation() {
    int hour = currentTime.hour % 12; // Convert to 12-hour format
    int minute = currentTime.minute;
    return ((hour * 30) + (minute * 0.5)) * (3.14159 / 180); // Each hour is 30 degrees, each minute adds 0.5 degrees
  }

  double getMinuteRotation() {
    int minute = currentTime.minute;
    return (minute * 6) * (3.14159 / 180); // Each minute is 6 degrees
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.velocity.pixelsPerSecond.dx > 0) {
          _speakReturnMessage();
          Navigator.pop(context);
        } else if (details.velocity.pixelsPerSecond.dx < 0) {
          _speakTime(formattedDate);
        }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurpleAccent, Colors.purpleAccent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 5,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Clock face
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.deepPurple, width: 6), // Clock face border color
                        ),
                      ),
                      // Center circle for hands to start
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.deepPurple, // Center circle color
                        ),
                      ),
                      // Hour hand
                      Transform.rotate(
                        angle: getHourRotation(),
                        child: Container(
                          width: 8, // Width of the hour hand
                          height: 30, // Height of the hour hand
                          color: Colors.deepPurple, // Hour hand color
                          alignment: Alignment.bottomCenter,
                          margin: EdgeInsets.only(bottom: 20), // Starts from center circle
                        ),
                      ),
                      // Minute hand
                      Transform.rotate(
                        angle: getMinuteRotation(),
                        child: Container(
                          width: 6, // Width of the minute hand
                          height: 40, // Height of the minute hand
                          color: Colors.deepPurple, // Minute hand color
                          alignment: Alignment.bottomCenter,
                          margin: EdgeInsets.only(bottom: 30), // Starts from center circle
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    formattedDate,
                    style: GoogleFonts.robotoMono(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple,
                      letterSpacing: 1.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _updateTime,
                    icon: Icon(Icons.refresh, color: Colors.white), // Refresh icon color
                    label: Text("Refresh Time", style: TextStyle(color: Colors.white)), // Button text color
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                  ),
                ],
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
    debugShowCheckedModeBanner: false, // Disable debug banner
  ));
}
