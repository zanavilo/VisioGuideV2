import 'package:flutter/material.dart';
import 'package:visioguide/Pages/PrivacyPolicy.dart'; // Import your PrivacyPolicy page

class TermOfService extends StatelessWidget {
  const TermOfService({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Terms of Service for Visio-Guide\n"
                    "Last Updated: [06/11/24]\n\n"
                    "Welcome to Visio-Guide, an application designed to assist visually impaired individuals by providing helpful tools such as text reading, object detection, and more. By downloading, installing, or using the Visio-Guide app, you agree to comply with and be bound by the following Terms of Service. Please read these terms carefully.\n\n"
                    "1. Acceptance of Terms\n"
                    "By accessing or using the Visio-Guide app, you agree to these Terms of Service. If you do not agree with any part of these terms, you must uninstall the app and cease any further use.\n\n"
                    "2. Use of the Application\n"
                    "Visio-Guide is intended to assist with specific tasks but is not a substitute for professional tools or services. You agree not to use the app for any illegal or unauthorized purpose, including but not limited to:\n"
                    "- As a mobility or navigation device.\n"
                    "- In any way that may cause harm to yourself or others.\n\n"
                    "3. Privacy Policy\n"
                    "Your privacy is important to us. Our Privacy Policy, which is incorporated into these Terms of Service, describes how we collect, use, and share information. Please review the Privacy Policy for more details.\n\n"
                    "4. Third-Party Services\n"
                    "Visio-Guide may integrate or interact with third-party services (such as text-to-speech, weather APIs, etc.). You acknowledge that we are not responsible for any issues arising from these third-party services, and the use of such services is governed by their respective terms and conditions.\n\n"
                    "5. Data Collection and Use\n"
                    "Visio-Guide may collect and store personal data as described in our Privacy Policy. By using the app, you consent to the collection and use of your data, which may include:\n"
                    "- Visual data processed through the camera.\n"
                    "- Voice commands and audio data.\n"
                    "All data is collected to improve the app’s functionality and is handled in accordance with applicable data protection laws.\n\n"
                    "6. Disclaimer of Warranties\n"
                    "Visio-Guide is provided on an \"as-is\" and \"as-available\" basis. We make no representations or warranties of any kind, express or implied, regarding the app’s functionality, accuracy, or reliability. We do not guarantee that the app will meet your expectations or that it will operate without interruption, errors, or defects.\n\n"
                    "7. Limitation of Liability\n"
                    "To the fullest extent permitted by law, Visio-Guide and its developers shall not be liable for any damages, including but not limited to indirect, incidental, or consequential damages arising from the use of or inability to use the app.\n\n"
                    "8. Changes to the Terms\n"
                    "We reserve the right to modify these Terms of Service at any time. Any changes will be effective immediately upon posting the updated terms. Your continued use of the app following any changes signifies your acceptance of the new terms.\n\n"
                    "9. Governing Law\n"
                    "These Terms of Service are governed by and construed in accordance with the laws of [Country], without regard to its conflict of law principles. Any disputes arising from these terms or your use of the app will be resolved in the courts of [Jurisdiction].\n\n"
                    "10. Contact Information\n"
                    "If you have any questions or concerns about these Terms of Service, please contact us at [CustomerSuport@gmail.com].",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => PrivacyPolicy()), // Navigate to PrivacyPolicy page
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
      ),
    );
  }
}
