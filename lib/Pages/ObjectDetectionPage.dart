import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter_tts/flutter_tts.dart'; // Import TTS package
import 'package:vibration/vibration.dart'; // Import Vibration package

class ObjectDetectionPage extends StatefulWidget {
  @override
  _ObjectDetectionPageState createState() => _ObjectDetectionPageState();
}

class _ObjectDetectionPageState extends State<ObjectDetectionPage> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  String _result = 'Detection Result:';
  bool _isLoading = false;
  final FlutterTts _flutterTts = FlutterTts(); // TTS instance
  String welcomeMessage = 'Click the button below to capture, or swipe right to go to the main page.'; // Welcome message

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras!.isEmpty) {
      print('No cameras available');
      return;
    }

    _cameraController = CameraController(
      _cameras![0],
      ResolutionPreset.high,
    );

    try {
      await _cameraController!.initialize();
      setState(() {});
      _speak(welcomeMessage); // Speak the welcome message when the camera is initialized
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> _speak(String text) async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.speak(text);
  }

  Future<void> _analyzeImage(XFile image) async {
    final bytes = await image.readAsBytes();
    print('Image size: ${bytes.length} bytes');

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://image-analysis-service-382965018642.us-central1.run.app/analyze-image'),
    );

    request.files.add(
      http.MultipartFile.fromBytes(
        'image',
        bytes,
        filename: image.name,
        contentType: MediaType('image', 'jpeg'),
      ),
    );

    try {
      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        setState(() {
          final decodedResponse = jsonDecode(responseData.body);
          final detectedObjects = decodedResponse['detectedObjects'];

          if (detectedObjects != null && detectedObjects is List && detectedObjects.isNotEmpty) {
            _result = detectedObjects.map((obj) => obj['name'].toString()).join(', ');
            _speakResultAndInstructions(_result); // Speak the result and instructions
          } else {
            _result = 'No objects detected';
            _speakNoObjectsDetected(); // Speak the no objects detected message
          }
        });
      } else {
        setState(() {
          _result = 'Error: ${response.statusCode} - ${responseData.body}';
        });
      }
    } catch (e) {
      print('HTTP request failed: $e');
      setState(() {
        _result = 'Request failed: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _speakNoObjectsDetected() async {
    await _speak("No objects detected."); // Speak "No objects detected" first
    await Future.delayed(Duration(seconds: 3)); // Add a small delay for clarity
    await _speak("Please try again."); // Then speak "Please try again"
  }

  Future<void> _speakResultAndInstructions(String result) async {
    await _speak(result); // Speak the result first
    await Future.delayed(Duration(seconds: 4)); // Add a small delay for clarity
    await _speak("Click the button again to capture or swipe right to go to the main page."); // Speak instructions
  }

  Future<void> _captureImage() async {
    setState(() {
      _isLoading = true;
    });

    // Add vibration effect when the button is clicked
    Vibration.vibrate();

    try {
      final XFile image = await _cameraController!.takePicture();
      await _analyzeImage(image);
    } catch (e) {
      print('Error capturing image: $e');
      setState(() {
        _result = 'Error: $e';
      });
    }
  }

  Future<void> _speakMainPage() async {
    await _speak("You are in the main page. Swipe left to read all the options.");
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.velocity.pixelsPerSecond.dx > 0) {
          _speakMainPage(); // Speak when swiping right
          Navigator.of(context).pop(); // Swipe right to go back to the main page
        }
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/wpg.png'), // Replace with your image asset
              fit: BoxFit.cover,
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final cameraHeight = constraints.maxHeight * 0.55;
              final resultHeight = constraints.maxHeight * 0.1; // Adjusted height
              final buttonHeight = constraints.maxHeight * 0.25;

              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(height: 10), // Extra spacing at the top

                  // Camera Preview
                  Container(
                    height: cameraHeight,
                    margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0), // Adjust top margin
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10.0,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: _cameraController == null
                          ? Center(child: CircularProgressIndicator())
                          : AspectRatio(
                        aspectRatio: _cameraController!.value.aspectRatio,
                        child: CameraPreview(_cameraController!),
                      ),
                    ),
                  ),

                  // Detection Result
                  Container(
                    height: resultHeight + 20, // Increased height by 20 pixels
                    margin: EdgeInsets.symmetric(horizontal: 20.0),
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10.0,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Detection Result:',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Text(
                              _result,
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Capture Button
                  // Capture Button with dimensions similar to ReadPage
                  Container(
                    width: 330,  // Set the width for ReadPage size
                    height: 180,  // Set the height for ReadPage size
                    margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _captureImage,
                      child: Text(
                        _isLoading ? 'Analyzing...' : 'Capture Image',
                        style: TextStyle(fontSize: 24),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(20), // Padding for visual structure
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                    ),
                  ),

                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ObjectDetectionPage(),
  ));
}


/* lacuata code
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // Import for MediaType

class ObjectDetectionPage extends StatefulWidget {
  @override
  _ObjectDetectionPageState createState() => _ObjectDetectionPageState();
}

class _ObjectDetectionPageState extends State<ObjectDetectionPage> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  String _result = 'Detection Result:';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    // Get available cameras
    _cameras = await availableCameras();
    if (_cameras!.isEmpty) {
      print('No cameras available');
      return;
    }

    // Initialize the camera controller
    _cameraController = CameraController(
      _cameras![0],
      ResolutionPreset.high,
    );

    try {
      await _cameraController!.initialize();
      setState(() {});
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  Future<void> _analyzeImage(XFile image) async {
    final bytes = await image.readAsBytes();

    // Logging to debug image size
    print('Image size: ${bytes.length} bytes');

    // Create a multipart request
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://image-analysis-service-382965018642.us-central1.run.app/analyze-image'),
    );

    // Adding the image file to the request
    request.files.add(
      http.MultipartFile.fromBytes(
        'image', // Name used in multer (upload.single('image'))
        bytes,
        filename: image.name,
        contentType: MediaType('image', 'jpeg'),
      ),
    );

    try {
      // Send the request
      final response = await request.send();
      final responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        setState(() {
          final decodedResponse = jsonDecode(responseData.body);
          _result = decodedResponse['detectedObjects'] != null
              ? decodedResponse['detectedObjects'].toString()
              : 'No objects detected';
        });
      } else {
        setState(() {
          _result = 'Error: ${response.statusCode} - ${responseData.body}';
        });
      }
    } catch (e) {
      print('HTTP request failed: $e');
      setState(() {
        _result = 'Request failed: $e';
      });
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator after analysis
      });
    }
  }

  Future<void> _captureImage() async {
    setState(() {
      _isLoading = true; // Show loading indicator during analysis
    });

    try {
      // Capture an image from the video feed
      final XFile image = await _cameraController!.takePicture();
      await _analyzeImage(image);
    } catch (e) {
      print('Error capturing image: $e');
      setState(() {
        _result = 'Error: $e';
      });
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose(); // Dispose of the camera controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/wpg.png'), // Background image
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 20.0),
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      if (_cameraController == null)
                        Center(child: CircularProgressIndicator())
                      else
                        AspectRatio(
                          aspectRatio: _cameraController!.value.aspectRatio,
                          child: CameraPreview(_cameraController!),
                        ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(15.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Detection Result:',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                        _result,
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _isLoading ? null : _captureImage,
                  child: Text(_isLoading ? 'Analyzing...' : 'Capture Image'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
*/


// WORKING CODE
/*
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; // Import this for MediaType

class ObjectDetectionPage extends StatefulWidget {
  @override
  _ObjectDetectionPageState createState() => _ObjectDetectionPageState();
}

class _ObjectDetectionPageState extends State<ObjectDetectionPage> {
  File? _image;
  String _result = '';
  bool _imageSelected = false; // Flag to track if an image has been selected

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _imageSelected = true; // Set flag to true when an image is selected
      });

      await _analyzeImage(_image!);
    }
  }

  Future<void> _analyzeImage(File image) async {
    final bytes = await image.readAsBytes();

    // Create a multipart request
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('https://image-analysis-service-382965018642.us-central1.run.app/analyze-image'),
    );

    // Adding the image file to the request
    request.files.add(
      http.MultipartFile.fromBytes(
        'image', // This should match the name used in multer (upload.single('image'))
        bytes,
        filename: image.path.split('/').last, // Use the filename of the image
        contentType: MediaType('image', 'jpeg'), // Adjust based on your image type
      ),
    );

    // Send the request
    final response = await request.send();

    // Read the response
    final responseData = await http.Response.fromStream(response);

    if (response.statusCode == 200) {
      setState(() {
        // Adjust based on your API response structure
        final decodedResponse = jsonDecode(responseData.body);
        _result = decodedResponse['detectedObjects'] != null
            ? decodedResponse['detectedObjects'].toString() // Modify this according to your response structure
            : 'No objects detected';
      });
    } else {
      setState(() {
        _result = 'Error: ${response.statusCode} - ${responseData.body}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Object Detection'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_image != null)
              Image.file(_image!)
            else
              Container(), // Show nothing when no image is selected

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: Text('Capture Image'),
            ),
            SizedBox(height: 20),
            if (_imageSelected) // Only show result if an image has been selected
              Expanded( // Use Expanded to allow scrolling within the available space
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.0), // Optional: padding for the scrollable area
                  child: Text(
                    'Detection Result: $_result',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
*/