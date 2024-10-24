import 'package:flutter/material.dart';
import 'package:visioguide/Pages/InfoSlider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllowAccess extends StatefulWidget {
  const AllowAccess({Key? key}) : super(key: key);

  @override
  _AllowAccessState createState() => _AllowAccessState();
}

class _AllowAccessState extends State<AllowAccess> {
  bool _isRequestingPermissions = false;
  bool _hasAccessedBefore = false;

  @override
  void initState() {
    super.initState();
    _checkIfAccessedBefore();
  }

  // Check if the user has accessed this screen before
  Future<void> _checkIfAccessedBefore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool accessedBefore = prefs.getBool('hasAccessedBefore') ?? false;

    if (accessedBefore) {
      // Navigate to InfoSlider if already accessed
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => InfoSlider()),
      );
    } else {
      // User is new; set the flag to true
      setState(() {
        _hasAccessedBefore = false;
      });
    }
  }

  // Method to request permissions
  Future<void> _requestPermissions() async {
    setState(() {
      _isRequestingPermissions = true;
    });

    // Request permissions for microphone, camera, and location
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      Permission.camera,
      Permission.location,           // Fine location
      Permission.locationWhenInUse,  // Coarse location
    ].request();

    // Check if all permissions are granted
    bool allGranted = statuses.values.every((status) => status.isGranted);

    setState(() {
      _isRequestingPermissions = false;
    });

    // If all permissions are granted, navigate to InfoSlider page
    if (allGranted) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('hasAccessedBefore', true); // Mark as accessed
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => InfoSlider()),
      );
    } else {
      // Show a SnackBar if some permissions were denied
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Some permissions were denied.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Allow access', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue, // Set AppBar background to blue
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/wpg.png'), // Background image
            fit: BoxFit.cover, // Cover the whole screen
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Camera icon with blue background
              Container(
                width: 150, // Adjust size as needed
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.blue, // Blue background for the icon
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera,
                  size: 80.0, // Adjust icon size as needed
                  color: Colors.white, // Set icon color to white
                ),
              ),
              const SizedBox(height: 30.0),
              const Text(
                'Microphone and Camera',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white), // Change text color to white
              ),
              const SizedBox(height: 10.0),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'To make video calls, give access to your microphone and camera.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, color: Colors.white), // Change text color to white
                ),
              ),
              const SizedBox(height: 40.0), // Increase spacing

              // Shortened button using SizedBox
              SizedBox(
                width: 200,  // Set the desired width for the button
                child: ElevatedButton(
                  onPressed: _isRequestingPermissions ? null : () => _requestPermissions(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 15.0), // Adjust button height if needed
                  ),
                  child: _isRequestingPermissions
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Give access', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
