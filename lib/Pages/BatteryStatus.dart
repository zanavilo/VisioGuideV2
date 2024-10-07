import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';

class BatteryStatus extends StatefulWidget {
  @override
  _BatteryStatusState createState() => _BatteryStatusState();
}

class _BatteryStatusState extends State<BatteryStatus> {
  final Battery _battery = Battery();
  int _batteryLevel = 0;

  @override
  void initState() {
    super.initState();
    _getBatteryLevel();
  }

  Future<void> _getBatteryLevel() async {
    final int batteryLevel = await _battery.batteryLevel;

    // If the widget is still mounted, update the UI
    if (mounted) {
      setState(() {
        _batteryLevel = batteryLevel;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Battery Status'),
      ),
      body: Center(
        child: Text(
          'Battery Level: $_batteryLevel%',
          style: TextStyle(fontSize: 24),
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
