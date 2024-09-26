import 'package:flutter/material.dart';
import 'MainPage.dart';
import 'package:permission_handler/permission_handler.dart';

class AllowAccess extends StatefulWidget {
  const AllowAccess({Key? key}) : super(key: key);

  @override
  _AllowAccessState createState() => _AllowAccessState();
}

class _AllowAccessState extends State<AllowAccess> {
  bool _isRequestingPermissions = false;
  // ... (rest of your permission handling code)

  Future<void> _requestPermissions() async {
    setState(() {
      _isRequestingPermissions = true;
    });

    // Request both fine and coarse location permissions, along with others
    Map<Permission, PermissionStatus> statuses = await [
      Permission.microphone,
      Permission.camera,
      Permission.location, // Fine location
      Permission.locationWhenInUse, // Coarse location
    ].request();

    // Check if all permissions are granted
    bool allGranted = statuses.values.every((status) => status.isGranted);

    setState(() {
      _isRequestingPermissions = false;
    });

    if (allGranted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    } else {
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container( // Wrap the icon in a Container for styling
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
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10.0),
            const Padding( // Add padding for better visual spacing
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'To make video calls, give access to your microphone and camera.',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40.0), // Increase spacing
            ElevatedButton(
              onPressed: _isRequestingPermissions ? null : () => _requestPermissions(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                minimumSize: const Size.fromHeight(50),
              ),
              child: _isRequestingPermissions
                  ? const CircularProgressIndicator(color: Colors.white) // White loading indicator
                  : const Text('Give access', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}