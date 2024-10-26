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
