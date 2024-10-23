import 'package:flutter/material.dart';
import 'package:visioguide/Pages/AllowAccess.dart';
import 'package:visioguide/Pages/TermOfService.dart';
import 'package:visioguide/Pages/PrivacyPolicy.dart'; // Import PrivacyPolicy

class PrivacyAndTerms extends StatefulWidget {
  const PrivacyAndTerms({super.key});

  @override
  _PrivacyAndTermsState createState() => _PrivacyAndTermsState();
}

class _PrivacyAndTermsState extends State<PrivacyAndTerms> {
  bool isPrivacyPolicyAccepted = false; // Track if the privacy policy checkbox is checked

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy and Terms', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/wpg.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
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
                    color: Colors.white,
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
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const TermOfServices()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Always blue
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text('Terms of Service and Privacy Policy', style: TextStyle(color: Colors.white)),
                ),

                const SizedBox(height: 32),

                const Text(
                  'By clicking "I agree", I agree to everything above and accept the Terms of Service and Privacy Policy.',
                  style: TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),

                // Checkbox for Privacy Policy acceptance
                Row(
                  children: [
                    Checkbox(
                      value: isPrivacyPolicyAccepted,
                      onChanged: (value) {
                        setState(() {
                          isPrivacyPolicyAccepted = value ?? false;
                        });
                      },
                    ),
                    const Expanded(
                      child: Text(
                        'I have read and accept the Privacy Policy.',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: isPrivacyPolicyAccepted // Only clickable if privacy policy accepted
                        ? () {
                      // Navigate to the Allow Access page
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const AllowAccess(),
                        ),
                      );
                    }
                        : null, // Disable if privacy policy not accepted
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Always blue
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

  Widget _buildTermRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

