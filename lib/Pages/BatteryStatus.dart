import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';

class BatteryStatus extends StatefulWidget {
  @override
  _BatteryStatusState createState() => _BatteryStatusState();
}

class _BatteryStatusState extends State<BatteryStatus> {
  final Battery _battery = Battery();
  int? _batteryLevel;

  @override
  void initState() {
    super.initState();
    _getBatteryLevel();
  }

  Future<void> _getBatteryLevel() async {
    final batteryLevel = await _battery.batteryLevel;
    setState(() {
      _batteryLevel = batteryLevel;
    });
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
            fit: BoxFit.cover, // Make the image cover the entire container
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display the appropriate battery image
              Image.asset(
                batteryImage,
                width: 100, // Adjust the width as needed
                height: 100, // Adjust the height as needed
              ),
              SizedBox(height: 20),
              Text(
                _batteryLevel != null
                    ? 'Battery Level: $_batteryLevel%'
                    : 'Loading...',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white, // Change the text color for better visibility
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
