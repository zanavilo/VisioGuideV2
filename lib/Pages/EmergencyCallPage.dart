import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_tts/flutter_tts.dart';

class EmergencyCallPage extends StatefulWidget {
  final String? savedPhoneNumber;

  EmergencyCallPage({this.savedPhoneNumber});

  @override
  _EmergencyCallPageState createState() => _EmergencyCallPageState();
}

class _EmergencyCallPageState extends State<EmergencyCallPage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  String? _savedPhoneNumber;
  bool _isCalling = false;
  final FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _loadSavedPhoneNumber();
  }

  Future<void> _loadSavedPhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedPhoneNumber = prefs.getString('savedPhoneNumber') ?? widget.savedPhoneNumber;
    });
    _speakWelcomeMessage();
  }

  Future<void> _savePhoneNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedPhoneNumber = _phoneNumberController.text;
      prefs.setString('savedPhoneNumber', _savedPhoneNumber!);
      _phoneNumberController.clear();
    });
    _speakWelcomeMessage();
  }

  Future<void> _speakWelcomeMessage() async {
    String message = "You are now in the emergency call page. The saved number is ${_savedPhoneNumber ?? 'not set'}. Click the button below to start calling.";
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.speak(message);
  }

  Future<void> _makeCall() async {
    if (_savedPhoneNumber != null) {
      setState(() {
        _isCalling = true;
      });

      await flutterTts.speak("Calling $_savedPhoneNumber...");

      await Future.delayed(Duration(seconds: 2));

      final Uri launchUri = Uri(
        scheme: 'tel',
        path: _savedPhoneNumber,
      );

      if (await canLaunch(launchUri.toString())) {
        await launch(launchUri.toString());
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Could not launch the dialer.")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No saved phone number to call.")),
      );
    }
  }

  void _endCall() {
    setState(() {
      _isCalling = false;
    });
  }

  Future<void> _speakMainPageMessage() async {
    await flutterTts.speak("You are in the main page. Swipe left to read all the options.");
  }

  void _navigateToMainPage() {
    _speakMainPageMessage();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent, // Set the background color of the Scaffold
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.velocity.pixelsPerSecond.dx > 0) {
            _navigateToMainPage();
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16.0, 150.0, 16.0, 16.0), // Set top padding to 150
          child: Container(
            color: Colors.transparent, // Make the container background transparent
            child: Column(
              mainAxisSize: MainAxisSize.min, // Use MainAxisSize.min to fit the content
              children: [
                if (_savedPhoneNumber != null)
                  Dismissible(
                    key: Key(_savedPhoneNumber!),
                    background: Container(color: Colors.red, child: Icon(Icons.call, color: Colors.white)),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (direction) async {
                      if (await Vibration.hasVibrator() ?? false) {
                        Vibration.vibrate(duration: 100);
                      }
                      _makeCall();
                    },
                    child: Card(
                      elevation: 5,
                      color: Colors.transparent, // Set Card background color to transparent
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(
                          'Saved Phone Number: $_savedPhoneNumber',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white), // Change text color to white
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: 20),
                TextField(
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                    labelText: "Enter Phone Number",
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _savePhoneNumber,
                  child: Text("Save Phone Number"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Keep this button blue
                    padding: EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  height: MediaQuery.of(context).size.height * 0.3,
                  margin: EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      await Vibration.vibrate();
                      _makeCall();
                    },
                    child: Center(
                      child: Text(
                        'Call Saved Number',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent, // Keep this button red
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      alignment: Alignment.center,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                if (_isCalling) ...[
                  Text(
                    "Calling $_savedPhoneNumber...",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white), // Change text color to white
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _endCall,
                    child: Text("End Call"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: EmergencyCallPage(),
    debugShowCheckedModeBanner: false,
  ));
}
