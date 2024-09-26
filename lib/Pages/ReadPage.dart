import 'package:flutter/material.dart';

class ReadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Read Text Using Camera'),
      ),
      body: Center(
        child: Text(
          'This is the page where you can read text using the camera.',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
