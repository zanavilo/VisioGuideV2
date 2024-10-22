import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:flutter_tts/flutter_tts.dart';

class BatteryStatus extends StatefulWidget {
  @override
  _BatteryStatusState createState() => _BatteryStatusState();
}

class _BatteryStatusState extends State<BatteryStatus> {
  final Battery _battery = Battery();
  int? _batteryLevel;
  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _getBatteryLevel();
  }

  // Get battery level and then speak the level
  Future<void> _getBatteryLevel() async {
    final batteryLevel = await _battery.batteryLevel;
    setState(() {
      _batteryLevel = batteryLevel;
    });
    _speakBatteryLevel(); // Trigger TTS after battery level is fetched
  }

  // Text-to-Speech function
  Future<void> _speakBatteryLevel() async {
    String text = _batteryLevel != null
        ? 'Battery Level is $_batteryLevel percent.'
        : 'Unable to retrieve battery level.';

    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(text);
  }

  @override
  Widget build(BuildContext context) {
    String batteryImage = _batteryLevel != null && _batteryLevel! > 20
        ? 'assets/battery_high.png'
        : 'assets/battery_low.png';

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/wpg.png'), // Background image
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display the appropriate battery image
              Image.asset(
                batteryImage,
                width: 100,
                height: 100,
              ),
              SizedBox(height: 20),
              Text(
                _batteryLevel != null
                    ? 'Battery Level: $_batteryLevel%'
                    : 'Loading...',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: BatteryStatus(),
  ));
}