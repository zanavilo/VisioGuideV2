import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'result_screen.dart'; // Ensure this path is correct

class ReadPage extends StatefulWidget {
  @override
  _ReadPageState createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  final textRecognizer = TextRecognizer();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    textRecognizer.close();
    super.dispose();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    _cameraController = CameraController(
      cameras[0],
      ResolutionPreset.high,
    );

    await _cameraController!.initialize();
    setState(() {
      _isCameraInitialized = true;
    });
  }

  Future<void> _captureAndRecognizeText() async {
    if (_cameraController == null || !_isCameraInitialized) return;

    try {
      final image = await _cameraController!.takePicture();
      final inputImage = InputImage.fromFilePath(image.path);
      final recognizedText = await textRecognizer.processImage(inputImage);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ResultScreen(text: recognizedText.text),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error capturing text: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Read Text Using Camera'),
      ),
      body: Column(
        children: [
          if (_isCameraInitialized)
            Expanded(
              flex: 7, // 70% of the screen
              child: CameraPreview(_cameraController!),
            ),
          Expanded(
            flex: 3, // 30% of the screen
            child: Center(
              child: ElevatedButton(
                onPressed: _captureAndRecognizeText,
                child: Text('Capture and Convert to Text'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
