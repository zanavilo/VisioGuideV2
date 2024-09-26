import 'package:flutter/material.dart';

class ObjectDetectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Object Detection'),
      ),
      body: Center(
        child: Text(
          'This is the page for object detection.',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
