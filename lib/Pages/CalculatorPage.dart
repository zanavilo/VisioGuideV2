import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt; // Import speech_to_text
import 'package:flutter_tts/flutter_tts.dart'; // Import flutter_tts

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  bool _isListening = false;
  String _resultText = 'Swipe left to activate voice command.'; // Default prompt text

  @override
  void initState() {
    super.initState();
    _initTTS(); // Initialize TTS settings
  }

  Future<void> _initTTS() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setSpeechRate(0.5); // Adjust speech rate as needed
  }

  Future<void> _startListening() async {
    if (!_isListening) {
      bool available = await _speech.initialize(
        onStatus: (val) {
          print('Speech recognition status: $val'); // Debugging line
        },
        onError: (val) {
          print('Speech recognition error: $val'); // Debugging line
        },
      );

      if (available) {
        setState(() {
          _isListening = true; // Set to listening state
          _resultText = 'Voice command activated. Listening...'; // Update the prompt text
        });
        await _flutterTts.speak('Voice command activated. Listening...');
        _speech.listen(
          onResult: (val) => _processResult(val.recognizedWords),
        );
      } else {
        print("Speech recognition not available."); // Debugging line
        await _flutterTts.speak('Speech recognition not available.');
      }
    }
  }

  void _processResult(String spokenText) {
    setState(() {
      _isListening = false; // Reset listening state
      _resultText = spokenText; // Show the recognized words
    });
    _calculateAndSpeak(spokenText); // Calculate result and speak it
  }

  Future<void> _calculateAndSpeak(String spokenText) async {
    try {
      final result = _evaluateExpression(spokenText);
      await _flutterTts.speak('The result is $result');
      setState(() {
        _resultText = 'Result: $result'; // Display the result
      });
    } catch (e) {
      await _flutterTts.speak('Sorry, I could not calculate that.');
    } finally {
      // Ensure that we can start listening again after processing
      await Future.delayed(Duration(seconds: 1)); // Delay to ensure user can hear the result
      _startListening(); // Restart listening after processing the result
    }
  }

  double _evaluateExpression(String spokenText) {
    // Replace words with symbols
    spokenText = spokenText.toLowerCase()
        .replaceAll('plus', '+')
        .replaceAll('minus', '-')
        .replaceAll('times', '*')
        .replaceAll('divided by', '/');

    // Split the input based on spaces and operators
    List<String> parts = spokenText.split(RegExp(r'[\s]+')); // Split by whitespace
    if (parts.length != 3) throw FormatException("Invalid format");

    double num1 = double.parse(parts[0]);
    String operator = parts[1];
    double num2 = double.parse(parts[2]);

    switch (operator) {
      case '+':
        return num1 + num2;
      case '-':
        return num1 - num2;
      case '*':
        return num1 * num2;
      case '/':
        return num1 / num2;
      default:
        throw FormatException("Invalid operator");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voice Command Calculator'),
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          print("Swipe detected: ${details.velocity.pixelsPerSecond.dx}");
          if (details.velocity.pixelsPerSecond.dx < 0) {
            print("Swipe left detected.");
            _startListening(); // Start listening for voice commands
          }
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _resultText,
                style: TextStyle(fontSize: 24), // Increased font size for result
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
