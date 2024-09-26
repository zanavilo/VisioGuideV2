import 'package:flutter/material.dart';

class BatteryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Battery Percentage'),
      ),
      body: Center(
        child: Text(
          'This is the page to display battery percentage.',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
