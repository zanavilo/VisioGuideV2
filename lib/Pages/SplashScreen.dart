import 'dart:async';
import 'package:flutter/material.dart';
import 'PrivacyAndTerms.dart'; // Import the Privacy and Terms screen

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Navigate to Privacy and Terms after a delay
    Timer(Duration(seconds: 3), () {
      // Use pushReplacement to replace the current screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => PrivacyAndTerms()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Image.asset('assets/logo.png'),
      ),
    );
  }
}