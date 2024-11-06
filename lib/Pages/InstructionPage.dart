import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';

class InstructionPage extends StatefulWidget {
  @override
  _InstructionPageState createState() => _InstructionPageState();
}

class _InstructionPageState extends State<InstructionPage> {
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _speakInstructions();
  }

  // TTS function to announce the instructions
  Future<void> _speakInstructions() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.4);

    // Combine all the instructions into a single string and speak them
    await flutterTts.speak(
        "The instructions for the Main Page are as follows. Swipe left to repeat all the options. "
            "Swipe right to activate the voice command. Say 'exit' to close the application. "
            "Now that you know the basic functions of Visio-Guide, just swipe right to return to the main page.");
  }

  // Speak return message when navigating back
  Future<void> _speakReturnMessage() async {
    String returnMessage = 'You are at the main page. Swipe left to read all the options.';
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(returnMessage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          // Detect right swipe
          if (details.velocity.pixelsPerSecond.dx > 0) {
            _speakReturnMessage(); // Speak return message before going back
            Navigator.pop(context); // Navigate back to MainPage
          }
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/wpg.png'), // Background image
              fit: BoxFit.cover, // Make the image cover the whole container
            ),
          ),
          child: Center( // Center the content vertically and horizontally
            child: SingleChildScrollView( // Use SingleChildScrollView to make it scrollable if needed
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Center the column vertically
                children: <Widget>[
                  _buildInstructionItem('SWIPE LEFT', 'to repeat all the options', 'assets/back.png'),
                  _buildInstructionItem('SWIPE RIGHT', 'to activate voice command', 'assets/back.png', flip: true),
                  _buildInstructionItem('EXIT', 'to close the application', 'assets/exit.png', isExit: true),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInstructionItem(String title, String description, String iconPath, {bool flip = false, bool isExit = false}) {
    // Flip the image only for 'SWIPE RIGHT'
    Widget icon = flip
        ? Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(3.14159), // Flip the image horizontally (180 degrees)
      child: Image.asset(iconPath, width: 50, height: 50),
    )
        : Image.asset(iconPath, width: 50, height: 50);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8), // Vertical margin between cards
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners for cards
      ),
      elevation: 5, // Shadow effect for the cards
      child: ListTile(
        leading: icon,
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        onTap: () {
          if (isExit) {
            // If it's the EXIT option, close the app
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          }
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: InstructionPage(),
  ));
}
