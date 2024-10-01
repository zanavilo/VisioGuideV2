import 'package:flutter/material.dart';
import 'package:visioguide/Pages/MainPage.dart';
import 'package:visioguide/Pages/InfoSlider.dart';
import 'AllowAccess.dart';

class PrivacyAndTerms extends StatefulWidget {
  const PrivacyAndTerms({super.key});

  @override
  _PrivacyAndTermsState createState() => _PrivacyAndTermsState();
}

class _PrivacyAndTermsState extends State<PrivacyAndTerms> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy and Terms', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue, // Match the blue color from the image
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'To use Visio-Guide, you agree to the following:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value ?? false;
                    });
                  },
                ),
                const Text('I agree to the terms'),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: isChecked
                    ? () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => InfoSlider()),
                  );
                }
                    : null, // Disable button if checkbox is not checked
                style: ElevatedButton.styleFrom(
                  backgroundColor: isChecked ? Colors.blue : Colors.grey, // Button color change when disabled
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('I agree', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build each term row
  Widget _buildTermRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
