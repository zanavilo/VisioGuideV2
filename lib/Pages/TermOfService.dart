import 'package:flutter/material.dart';
import 'package:visioguide/Pages/PrivacyPolicy.dart';

class TermOfServices extends StatefulWidget {
  const TermOfServices({super.key});

  @override
  _TermOfServicesState createState() => _TermOfServicesState();
}

class _TermOfServicesState extends State<TermOfServices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Terms of Service\nVisio-Guide App\nLast updated: [Date]\n',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const Text(
              'Welcome to Visio-Guide, an application designed to assist visually impaired individuals by providing helpful tools such as text reading, object detection, and more. By using our app, you agree to the following terms and conditions. Please read them carefully.\n',
              style: TextStyle(fontSize: 16),
            ),
            _buildSectionTitle('1. Acceptance of Terms'),
            const Text(
              'By downloading, installing, or using Visio-Guide, you agree to comply with and be bound by these Terms of Service. If you do not agree to these terms, you should uninstall the app and discontinue its use.\n',
            ),
            _buildSectionTitle('2. Use of the Application'),
            const Text(
              'Visio-Guide is designed to assist in certain tasks but is not a substitute for professional tools or services. You agree not to use the app:\n- As a mobility or navigation device.\n- For any illegal or unauthorized purpose.\n- In any way that may cause harm to yourself or others.\n',
            ),
            _buildSectionTitle('3. Privacy Policy'),
            const Text(
              'Our Privacy Policy, which is incorporated into these terms, describes how we collect, use, and share information. Please review the [Privacy Policy] for more information.\n',
            ),
            _buildSectionTitle('4. Third-Party Services'),
            const Text(
              'Visio-Guide may integrate or interact with third-party services (such as text-to-speech, weather APIs, etc.). You acknowledge that we are not responsible for any issues arising from third-party services and that the use of such services is governed by their own terms and conditions.\n',
            ),
            _buildSectionTitle('5. Data Collection and Use'),
            const Text(
              'Visio-Guide may collect and store personal data as described in our Privacy Policy. By using the app, you consent to the collection and use of your data, including but not limited to:\n- Visual data processed through the camera.\n- Voice commands and audio data.\nAll data is collected for the purpose of improving the app’s functionality and is handled in accordance with applicable data protection laws.\n',
            ),
            _buildSectionTitle('6. Disclaimer of Warranties'),
            const Text(
              'Visio-Guide is provided on an "as-is" and "as-available" basis. We make no representations or warranties of any kind, express or implied, regarding the app’s functionality, accuracy, or reliability. We do not guarantee that the app will meet your expectations or that it will operate without interruption, errors, or defects.\n',
            ),
            _buildSectionTitle('7. Limitation of Liability'),
            const Text(
              'To the fullest extent permitted by law, Visio-Guide and its developers shall not be liable for any damages, including but not limited to indirect, incidental, or consequential damages arising from the use of or inability to use the app.\n',
            ),
            _buildSectionTitle('8. Changes to the Terms'),
            const Text(
              'We reserve the right to modify these Terms of Service at any time. Any changes will be effective immediately upon posting the updated terms. Your continued use of the app following any changes signifies your acceptance of the new terms.\n',
            ),
            _buildSectionTitle('9. Governing Law'),
            const Text(
              'These Terms of Service are governed by and construed in accordance with the laws of [Country], without regard to its conflict of law principles. Any disputes arising from these terms or your use of the app will be resolved in the courts of [Jurisdiction].\n',
            ),
            _buildSectionTitle('10. Contact Information'),
            const Text(
              'If you have any questions or concerns about these Terms of Service, please contact us at [Support Email].\n',
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PrivacyPolicy()), // Navigates to Privacy Policy
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('Next', style: TextStyle(color: Colors.white)),
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
}
