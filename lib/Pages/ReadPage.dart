import 'package:flutter/material.dart';

class ReadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Read Text'),
      ),
      body: Center(
        child: Text(
          'This is the page where you can use the camera to read text.',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
