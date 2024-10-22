import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt; // For speech recognition
import 'package:flutter_tts/flutter_tts.dart'; // For text-to-speech
import 'package:vibration/vibration.dart'; // For vibration feedback

void main() {
  runApp(VoiceCalculatorApp());
}

class VoiceCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice Command Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CalculatorPage(),
    );
  }
}

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final stt.SpeechToText _speech = stt.SpeechToText(); // Speech recognition instance
  final FlutterTts _flutterTts = FlutterTts(); // TTS instance
  bool _isListening = false; // To track if it's listening
  String _resultText = 'Tap the button below to start solving a math problem.'; // Default text
  String _spokenText = ''; // Store recognized text

  @override
  void initState() {
    super.initState();
    _initializeTTS(); // Initialize TTS when the app starts
    _speakDefaultText(); // Speak the default text when the page opens
  }

  // Initialize Text-to-Speech settings
  Future<void> _initializeTTS() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5); // Adjust the speech rate if necessary
  }

  // Speak the default text
  Future<void> _speakDefaultText() async {
    await _flutterTts.speak(_resultText);
  }

  // Start listening to voice input
  Future<void> _startListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      if (available) {
        setState(() {
          _isListening = true;
          _resultText = 'Listening...'; // Update UI to show that it's listening
        });
        _speech.listen(
          onResult: (val) => _processResult(val.recognizedWords),
          listenFor: Duration(seconds: 5), // Set listening duration to 5 seconds
        );
      }
    }
  }

  // Process the recognized voice input
  void _processResult(String spokenText) {
    setState(() {
      _isListening = false;
      _spokenText = spokenText; // Store the spoken math problem
    });
    _calculateAndSpeak(spokenText); // Calculate and speak the result
  }

  // Convert spoken math expression to result and speak it
  Future<void> _calculateAndSpeak(String spokenText) async {
    try {
      final result = _evaluateExpression(spokenText).round(); // Round the result to the nearest integer
      await _flutterTts.speak('The result is $result'); // Speak the result
      setState(() {
        _resultText = 'Result: $result'; // Display the rounded result
      });
    } catch (e) {
      print(e); // Print error for debugging
      setState(() {
        _resultText = '....'; // Show a neutral error message
      });
    }
  }

  // Evaluate basic math expressions like "3000000 plus 4000000"
  double _evaluateExpression(String spokenText) {
    spokenText = spokenText.toLowerCase()
        .replaceAll('plus', '+')
        .replaceAll('minus', '-')
        .replaceAll('times', '*')
        .replaceAll('divided by', '/')
        .replaceAll(',', ''); // Remove commas for large numbers

    List<String> parts = spokenText.split(RegExp(r'[\s]+')); // Split by spaces
    if (parts.length != 3) throw FormatException("Invalid format");

    // Attempt to parse each part and catch potential errors
    double num1;
    double num2;

    try {
      num1 = double.parse(parts[0]);
      num2 = double.parse(parts[2]);
    } catch (e) {
      throw FormatException("Could not parse numbers");
    }

    String operator = parts[1];

    switch (operator) {
      case '+':
        return num1 + num2;
      case '-':
        return num1 - num2;
      case '*':
        return num1 * num2;
      case '/':
        if (num2 == 0) throw FormatException("Division by zero");
        return num1 / num2;
      default:
        throw FormatException("Invalid operator");
    }
  }

  // Handle swipe gesture
  void _onSwipeRight() async {
    await _flutterTts.speak("You are at the main page swipe left to read all the options");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voice Command Calculator'),
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.velocity.pixelsPerSecond.dx > 0) {
            _onSwipeRight(); // Trigger swipe right action
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  _resultText,
                  style: TextStyle(fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.3, // Button container height (30% of screen)
              child: ElevatedButton(
                onPressed: () async {
                  await Vibration.vibrate(); // Vibration on button tap
                  _startListening(); // Start listening when button is pressed
                },
                child: Text('Start Voice Command'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
