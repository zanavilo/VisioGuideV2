import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:vibration/vibration.dart'; // Import vibration package
import 'package:flutter_tts/flutter_tts.dart'; // Import TTS package
import 'result_screen.dart'; // Ensure this path is correct

class ReadPage extends StatefulWidget {
  @override
  _ReadPageState createState() => _ReadPageState();
}

class _ReadPageState extends State<ReadPage> {
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  final textRecognizer = TextRecognizer();
  final FlutterTts flutterTts = FlutterTts(); // TTS instance

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _speakWelcomeMessage(); // Call TTS method to speak welcome message
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
      // Vibrate on button press
      await Vibration.vibrate();

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

  Future<void> _speakWelcomeMessage() async {
    String welcomeMessage = 'Click the bottom button to capture.'; // The message to be spoken
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5); // Adjust speech rate as needed
    await flutterTts.speak(welcomeMessage); // Speak the message
  }

  Future<void> _speakReturnMessage() async {
    String returnMessage = 'You are at the main page, swipe left to read all the options.';
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5); // Adjust speech rate as needed
    await flutterTts.speak(returnMessage);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.velocity.pixelsPerSecond.dx > 0) {
          _speakReturnMessage();
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Read Text Using Camera'),
        ),
        body: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image(
                image: AssetImage("assets/wpg.png"),
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: [
                if (_isCameraInitialized)
                  Expanded(
                    flex: 7, // 70% of the screen
                    child: CameraPreview(_cameraController!),
                  ),
                Expanded(
                  flex: 3, // 30% of the screen
                  child: Center(
                    child: SizedBox(
                      width: 330, // Width to make it vertically long
                      height: 180, // Height to make it vertically long
                      child: ElevatedButton(
                        onPressed: _captureAndRecognizeText,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlueAccent, // Set button color to blue
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40), // Circular edges
                          ),
                          padding: EdgeInsets.all(20),
                        ),
                        child: Text(
                          'Capture',
                          style: TextStyle(fontSize: 18, color: Colors.white), // Set text color to white
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
