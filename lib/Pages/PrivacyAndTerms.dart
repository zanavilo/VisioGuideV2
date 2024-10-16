import 'package:flutter/material.dart';
import 'package:visioguide/Pages/AllowAccess.dart';
import 'package:visioguide/Pages/InfoSlider.dart';

class PrivacyAndTerms extends StatefulWidget {
  const PrivacyAndTerms({super.key});

  @override
  _PrivacyAndTermsState createState() => _PrivacyAndTermsState();
}

class _PrivacyAndTermsState extends State<PrivacyAndTerms> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy and Terms', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/wpg.png"),
                fit: BoxFit.cover, // Make sure the image covers the screen
              ),
            ),
          ),
          // The content of the page
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'To use Visio-Guide, you agree to the following:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white, // Make the text visible over the background
                  ),
                ),
                const SizedBox(height: 16),
                _buildTermRow(Icons.accessibility_new, 'I will not use Visio-Guide as a mobility device.'),
                const SizedBox(height: 16),
                _buildTermRow(Icons.camera_alt, 'Visio-Guide can record, review, and share videos and images for safety, quality, and as further described in the Privacy Policy.'),
                const SizedBox(height: 16),
                _buildTermRow(Icons.lock, 'The data, videos, images, and personal information I submit to Visio-Guide may be stored and processed.'),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Navigate to Terms of Service page
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text('Terms of Service', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Navigate to Privacy Policy page
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text('Privacy Policy', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 32),
                const Text(
                  'By clicking "I agree", I agree to everything above and accept the Terms of Service and Privacy Policy.',
                  style: TextStyle(color: Colors.white), // Ensure readability
                ),
                const SizedBox(height: 24), // Increased spacing
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => AllowAccess()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text('I agree', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to build each term row
  Widget _buildTermRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, color: Colors.white), // Make text color white
          ),
        ),
      ],
    );
  }
}