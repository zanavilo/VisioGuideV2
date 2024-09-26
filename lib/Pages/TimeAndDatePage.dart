import 'package:flutter/material.dart';

class TimeAndDatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time and Date'),
      ),
      body: Center(
        child: Text(
          'This is the page for checking time and date.',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
