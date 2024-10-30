import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart'; // Import TTS package
import 'package:visioguide/Pages/MainPage.dart'; // Import your MainPage file
import 'package:vibration/vibration.dart'; // Import vibration package

class ResultScreen extends StatefulWidget {
  final String text;

  ResultScreen({required this.text});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final FlutterTts flutterTts = FlutterTts(); // TTS instance

  @override
  void initState() {
    super.initState();
    _speakRecognizedText();
  }

  Future<void> _speakRecognizedText() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5); // Adjust speech rate as needed

    // Create the instruction message
    String instructions = 'Swipe right to go back to read more or swipe left to go to the main page.';

    // Combine recognized text with instructions
    String textToSpeak = widget.text.isNotEmpty
        ? '${widget.text}. $instructions'
        : 'No text recognized. $instructions';

    await flutterTts.speak(textToSpeak); // Speak the combined text
  }

  Future<void> _speakRightSwipeMessage() async {
    String message = 'Click the bottom button to capture.';
    await flutterTts.speak(message); // Speak the right swipe message
  }

  Future<void> _navigateToMainPage() async {
    Navigator.pushReplacement( // Navigate to MainPage
      context,
      MaterialPageRoute(builder: (context) => MainPage()), // Replace MainPage with your actual main page widget
    );
  }

  Future<void> _speakLeftSwipeMessage() async {
    String message = 'You are at the main page, swipe left to read all the options.';
    await flutterTts.speak(message); // Speak the left swipe message
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) async {
        // Detect right swipe
        if (details.velocity.pixelsPerSecond.dx > 0) {
          await Vibration.vibrate(); // Vibrate on right swipe
          Navigator.pop(context); // Navigate back to the previous page
          await _speakRightSwipeMessage(); // Speak right swipe message after navigating back
        }
        // Detect left swipe
        else if (details.velocity.pixelsPerSecond.dx < 0) {
          await _navigateToMainPage(); // Navigate to MainPage first
          await Future.delayed(Duration(seconds: 1)); // Wait a bit before speaking
          await _speakLeftSwipeMessage(); // Speak left swipe message after navigating
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Background image
            Positioned.fill(
              child: Image(
                image: AssetImage("assets/wpg.png"),
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8, // 80% width of screen
                height: MediaQuery.of(context).size.height * 0.6, // 60% height of screen
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20), // Rounded corners
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Text(
                    widget.text.isNotEmpty ? widget.text : 'No text recognized.',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    flutterTts.stop(); // Stop TTS when disposing of the widget
    super.dispose();
  }
}
