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