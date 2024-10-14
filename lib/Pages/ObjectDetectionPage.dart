import 'package:flutter/material.dart';

class ObjectDetectionPage extends StatelessWidget {
  bool isWorking = false;
  String result = "";
  CameraController cameraController;
  CameraImage imgCamera;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Object Detection'),
      ),
      body: Center(
        child: Text(
          'This is the page for object detection functionality.',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
