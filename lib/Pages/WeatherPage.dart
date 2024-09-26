import 'package:flutter/material.dart';

class WeatherPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Details'),
      ),
      body: Center(
        child: Text(
          'This is the page to check the weather details.',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
