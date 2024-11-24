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
      home: MainPage(), // Set MainPage as the initial home page
    );
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate to the calculator page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CalculatorPage()),
            );
          },
          child: Text('Go to Voice Calculator'),
        ),
      ),
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
  late Future<void> _timeoutFuture; // Future for the timeout

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
        _timeoutFuture = Future.delayed(Duration(seconds: 6), _resetListeningState); // Set a timeout of 6 seconds
        _speech.listen(
          onResult: (val) => _processResult(val.recognizedWords),
          listenFor: Duration(seconds: 5), // Set listening duration to 5 seconds
        );
      }
    }
  }

  // Reset the listening state if no input is received within the timeout
  void _resetListeningState() {
    if (_isListening) {
      setState(() {
        _isListening = false;
        _resultText = 'Tap the button below to start solving a math problem.'; // Reset the text
      });
      _speakDefaultText(); // Speak the reset message
    }
  }

  // Process the recognized voice input
  void _processResult(String spokenText) {
    setState(() {
      _isListening = false;
      _spokenText = spokenText; // Store the spoken math problem
    });
    _timeoutFuture = Future.value(); // Cancel the timeout
    _calculateAndSpeak(spokenText); // Calculate and speak the result
  }

  // Convert spoken math expression to result and speak it
  Future<void> _calculateAndSpeak(String spokenText) async {
    try {
      // Delay to ensure the text-to-speech has time to complete
      // await Future.delayed(Duration(seconds: 5));

      // Evaluate the mathematical expression
      final result = _evaluateExpression(spokenText).round(); // Round the result to the nearest integer

      // Update the UI to show the result
      setState(() {
        _resultText = 'Result: $result'; // Display the rounded result
      });

      // Speak the result
      await _flutterTts.speak('$spokenText equals $result'); // Speak the result
    } catch (e) {
      print(e); // Print error for debugging
      /*setState(() {
        _resultText = 'I couldn\'t understand that. Please try again.'; // Show an error message
      });

      // Speak the error message
      await _flutterTts.speak('I couldn\'t understand that. Please try again.');*/
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
    // Optionally, you can also navigate back to the MainPage if desired
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => MainPage()),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.velocity.pixelsPerSecond.dx > 0) {
            _onSwipeRight(); // Trigger swipe right action
            // You may also want to navigate back to the main page
            Navigator.pop(context); // Navigate back to MainPage
          }
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/wpg.png'), // Background image
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(16), // Add some padding
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9), // Set background color to white with some opacity
                      borderRadius: BorderRadius.circular(15), // Set border radius
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10.0,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      _resultText,
                      style: TextStyle(fontSize: 24, color: Colors.black), // Change text color to black for contrast
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.3, // Button container height (30% of screen)
                margin: EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
                child: ElevatedButton(
                  onPressed: () async {
                    await Vibration.vibrate(); // Vibration on button tap
                    _startListening(); // Start listening when button is pressed
                  },
                  child: Center( // Center the text within the button
                    child: Text(
                      'Start Voice Command',
                      textAlign: TextAlign.center, // Align the text to the center
                      style: TextStyle(fontSize: 20), // Optional: Adjust font size if needed
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Adjust padding to reduce width
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0), // Set rounded corners
                    ),
                    alignment: Alignment.center, // Ensure the button's child is centered
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
