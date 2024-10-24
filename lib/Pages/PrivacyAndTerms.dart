import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visioguide/Pages/AllowAccess.dart';
import 'package:visioguide/Pages/TermsOfService.dart'; // Import the TermOfService page

class PrivacyAndTerms extends StatefulWidget {
  const PrivacyAndTerms({super.key});

  @override
  _PrivacyAndTermsState createState() => _PrivacyAndTermsState();
}

class _PrivacyAndTermsState extends State<PrivacyAndTerms> {
  bool _isAgreed = false; // Variable to track checkbox state
  bool _isFirstVisit = true; // Variable to track if it's the first visit

  @override
  void initState() {
    super.initState();
    _checkFirstVisit();
  }

  Future<void> _checkFirstVisit() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? hasAgreed = prefs.getBool('hasAgreedTerms');

    if (hasAgreed == true) {
      // If the user has already agreed, navigate to AllowAccess
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AllowAccess()),
      );
    } else {
      setState(() {
        _isFirstVisit = true; // Show the terms and conditions
      });
    }
  }

  Future<void> _acceptTerms() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasAgreedTerms', true); // Set the flag to true

    // Navigate to AllowAccess
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const AllowAccess()),
    );
  }

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
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const TermOfService()), // Navigate to TermOfService page
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text('Terms of Services & Privacy Policy', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 32),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _isAgreed,
                      onChanged: (bool? value) {
                        setState(() {
                          _isAgreed = value ?? false;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: const Text(
                        'By checking this, I confirm that I have read, understand, and agree to the Terms of Service and Privacy Policy.',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24), // Increased spacing
                Center(
                  child: ElevatedButton(
                    onPressed: _isAgreed
                        ? () {
                      _acceptTerms(); // Call the method to accept terms
                    }
                        : null, // Disable button if not agreed
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isAgreed ? Colors.blue : Colors.grey, // Gray when disabled
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: Text(
                      'I agree',
                      style: TextStyle(
                        color: _isAgreed ? Colors.white : Colors.black, // Black text when disabled
                      ),
                    ),
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
