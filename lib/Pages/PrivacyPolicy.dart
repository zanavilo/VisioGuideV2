import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Privacy Policy\nVisio-Guide App\nLast updated: [Date]\n',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const Text(
              'At Visio-Guide, we are committed to protecting the privacy and security of our users\' personal information. This Privacy Policy explains how we collect, use, and disclose information when you use our app. By using Visio-Guide, you agree to the collection and use of information in accordance with this policy.\n',
              style: TextStyle(fontSize: 16),
            ),
            _buildSectionTitle('1. Information We Collect'),
            const Text(
              'We collect the following types of information to provide and improve the Visio-Guide experience:\n',
              style: TextStyle(fontSize: 16),
            ),
            _buildSubSectionTitle('a. Personal Information'),
            const Text(
              'When using certain features of Visio-Guide, we may collect personal information, including but not limited to:\n- Voice commands and audio data.\n- Images and text captured via the camera for text reading or object detection.\n- Geolocation data (for navigation or weather features).\n',
            ),
            _buildSubSectionTitle('b. Non-Personal Information'),
            const Text(
              'We may collect non-personal information that does not identify you directly, such as:\n- Device information (e.g., device model, operating system version).\n- App usage data (e.g., frequency of feature use).\n',
            ),
            _buildSectionTitle('2. How We Use Your Information'),
            const Text(
              'We use the information collected for the following purposes:\n',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              '- Improving App Functionality: Personal information, such as voice commands and camera inputs, is used to provide core features like text reading, object detection, and other assistive services.\n'
                  '- Customization: To personalize your experience based on your preferences.\n'
                  '- Analytics: Non-personal data is used for analytics to improve app performance and troubleshoot issues.\n'
                  '- Communication: To respond to support requests or feedback.\n',
            ),
            _buildSectionTitle('3. Data Sharing and Disclosure'),
            const Text(
              'We do not sell, trade, or rent your personal information to third parties. However, we may share data with third parties in the following instances:\n',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              '- Service Providers: We may work with third-party service providers to help operate our app (e.g., text-to-speech engines or cloud storage for data processing). These providers have access to personal information only to perform specific tasks on our behalf.\n'
                  '- Legal Requirements: We may disclose your information if required to do so by law or if we believe that such action is necessary to comply with legal obligations, protect our rights, or prevent fraud.\n',
            ),
            _buildSectionTitle('4. Data Retention'),
            const Text(
              'We retain your personal data only for as long as is necessary to fulfill the purposes outlined in this Privacy Policy. We will retain and use your information to the extent necessary to comply with our legal obligations, resolve disputes, and enforce our agreements.\n',
            ),
            _buildSectionTitle('5. Security of Your Information'),
            const Text(
              'We take reasonable measures to protect your personal information from unauthorized access, use, or disclosure. However, please remember that no method of transmission over the Internet or method of electronic storage is 100% secure, and we cannot guarantee its absolute security.\n',
            ),
            _buildSectionTitle('6. Your Rights'),
            const Text(
              'You have certain rights regarding your personal information, including:\n',
              style: TextStyle(fontSize: 16),
            ),
            const Text(
              '- The right to access and request copies of your personal information.\n'
                  '- The right to request the correction of inaccurate information.\n'
                  '- The right to request the deletion of your personal information under certain conditions.\n'
                  '- The right to withdraw consent for data processing at any time.\n',
            ),
            _buildSectionTitle('7. Changes to This Privacy Policy'),
            const Text(
              'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page. You are advised to review this Privacy Policy periodically for any changes.\n',
            ),
            _buildSectionTitle('8. Contact Us'),
            const Text(
              'If you have any questions or concerns about this Privacy Policy, please contact us at [Support Email].\n',
            ),
            const SizedBox(height: 20), // Adds space before the button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to PrivacyAndTerms.dart
                  Navigator.pushNamed(context, '/PrivacyAndTerms'); // Ensure the route is defined
                },
                child: const Text('Back to Privacy and Terms'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to build section titles
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  // Helper function to build subsection titles
  Widget _buildSubSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0, left: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
