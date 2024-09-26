import 'dart:async';
import 'package:flutter/material.dart';
import 'package:visioguide/Pages/MainPage.dart';
import 'package:visioguide/Pages/PrivacyAndTerms.dart'; // Ensure this import is correct
import 'package:visioguide/Pages/AllowAccess.dart'; // Ensure this import is correct

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice Command App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/', // Set the initial route to the splash screen
      routes: {
        '/': (context) => SplashScreen(), // Splash screen route
        '/PrivacyAndTerms': (context) => PrivacyAndTerms(), // Privacy and Terms screen route
        '/MainPage': (context) => MainPage(), // Main page route
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  double _opacity = 0.0; // Initial opacity set to 0 for fade-in
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Start the fade-in animation
    _controller = AnimationController(
      duration: const Duration(seconds: 3), // Total duration for fade-in and hold
      vsync: this,
    );

    // Set the opacity to 1.0 after a small delay (fade-in)
    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0; // Fade-in opacity
      });
    });

    // Navigate to the PrivacyAndTerms screen after the splash screen
    Timer(const Duration(seconds: 3), () {
      setState(() {
        _opacity = 0.0; // Start fade-out
      });
      Timer(const Duration(milliseconds: 500), () {
        Navigator.of(context).pushReplacementNamed('/PrivacyAndTerms'); // Navigate to PrivacyAndTerms
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Background color of the splash screen
      body: AnimatedOpacity(
        opacity: _opacity, // Apply opacity
        duration: const Duration(milliseconds: 500), // Duration for fade-in and fade-out
        child: Center(
          child: Image.asset('assets/logo.png'), // Splash logo image
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
