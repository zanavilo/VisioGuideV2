import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller; // Declare the camera controller
  late Future<void> _initializeControllerFuture; // Future for controller initialization

  @override
  void initState() {
    super.initState();
    _initializeCamera(); // Initialize the camera when the widget is created
  }

  // Method to initialize the camera
  Future<void> _initializeCamera() async {
    // Get a list of the available cameras
    final cameras = await availableCameras();

    // Check if any cameras are available
    if (cameras.isNotEmpty) {
      // Use the first camera (usually the back camera)
      _controller = CameraController(
        cameras.first, // Use the first camera in the list
        ResolutionPreset.high, // Set the resolution
      );

      // Initialize the controller and set the future
      _initializeControllerFuture = _controller.initialize();
    } else {
      throw Exception("No cameras available");
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the controller when done
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // When the camera is initialized, display the camera preview
            return CameraPreview(_controller);
          } else if (snapshot.hasError) {
            // Display an error message if the initialization failed
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Show a loading indicator while the camera is initializing
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            // Wait for the camera to be initialized before taking a picture
            await _initializeControllerFuture;

            // Take a picture and save it to the specified path
            final image = await _controller.takePicture();
            // You can then use the image file
            print('Picture taken: ${image.path}');
          } catch (e) {
            // Handle any errors that occur during the picture-taking process
            print("Error taking picture: $e");
          }
        },
        child: Icon(Icons.camera_alt),
      ),
    );
  }
}
