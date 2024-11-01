import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AllowAccess.dart'; // Ensure you have this page
import 'MainPage.dart'; // Ensure you have this page

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(Duration(seconds: 3)); // Duration of the splash screen

    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool onboardingSeen = prefs.getBool('onboarding_seen') ?? false;

    // Check if the user is returning; if they are, navigate directly to MainPage
    if (onboardingSeen) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    } else {
      // For new users, navigate to AllowAccess
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AllowAccess()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const CircularProgressIndicator(color: Colors.white),
            const SizedBox(height: 20),
            const Text(
              'Welcome to Visio-Guide',
              style: TextStyle(fontSize: 24, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
