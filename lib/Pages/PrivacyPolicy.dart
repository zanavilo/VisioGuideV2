import 'package:flutter/material.dart';
import 'package:visioguide/Pages/PrivacyAndTerms.dart'; // Import your PrivacyAndTerms page

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Privacy Policy for Visio-Guide\n"
                    "Last Updated: [Date]\n\n"
                    "This Privacy Policy describes how Visio-Guide (\"we,\" \"our,\" or \"us\") collects, uses, and shares personal information when you use our application designed to assist visually impaired individuals.\n\n"
                    "By using Visio-Guide, you consent to the data practices described in this policy. If you do not agree with the terms of this policy, please do not use our app.\n\n"
                    "1. Information We Collect\n"
                    "   Personal Data\n"
                    "   We may collect the following personal information when you use Visio-Guide:\n"
                    "   - Visual Data: Data captured through your device's camera to assist with object detection and text reading.\n"
                    "   - Audio Data: Voice commands and audio recordings to facilitate user interaction and enhance functionality.\n\n"
                    "   Non-Personal Data\n"
                    "   We may also collect non-personal information that does not directly identify you, including:\n"
                    "   - Device information (e.g., model, operating system).\n"
                    "   - Usage data (e.g., time spent on the app, features used).\n\n"
                    "2. How We Use Your Information\n"
                    "   We use the information we collect for the following purposes:\n"
                    "   - To Provide and Maintain Our App: To deliver the features and functionalities of Visio-Guide.\n"
                    "   - To Improve Our App: To analyze usage and make enhancements.\n"
                    "   - To Communicate with You: To respond to inquiries, provide customer support, and send updates regarding the app.\n"
                    "   - To Ensure Security: To monitor for potential security threats and fraudulent activity.\n\n"
                    "3. Data Sharing and Disclosure\n"
                    "   We do not sell or rent your personal information to third parties. However, we may share your information in the following situations:\n"
                    "   - With Service Providers: We may employ third-party companies to facilitate our services, such as cloud storage providers. These service providers will only have access to your information to perform specific tasks on our behalf.\n"
                    "   - For Legal Reasons: We may disclose your information if required to do so by law or in response to valid requests by public authorities (e.g., a court or a government agency).\n\n"
                    "4. Data Security\n"
                    "   We take the security of your personal information seriously. We implement appropriate technical and organizational measures to protect your data against unauthorized access, loss, or destruction. However, no method of transmission over the internet or electronic storage is 100% secure. Therefore, we cannot guarantee its absolute security.\n\n"
                    "5. Your Choices\n"
                    "   You have the following rights regarding your personal information:\n"
                    "   - Access and Update: You can access and update your information through the app's settings.\n"
                    "   - Opt-Out: You can opt out of certain data collection by disabling specific features in your device settings.\n"
                    "   - Delete Data: You can request the deletion of your personal data by contacting us.\n\n"
                    "6. Children’s Privacy\n"
                    "   Visio-Guide is not intended for use by children under the age of 13. We do not knowingly collect personal information from children. If we become aware that we have collected personal data from a child, we will take steps to delete such information.\n\n"
                    "7. Changes to This Privacy Policy\n"
                    "   We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new policy in the app and updating the \"Last Updated\" date at the top of this policy. Your continued use of the app after changes indicates your acceptance of the new terms.\n\n"
                    "8. Contact Us\n"
                    "   If you have any questions or concerns about this Privacy Policy, please contact us at [Support Email].",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => const PrivacyAndTerms()), // Navigate to PrivacyAndTerms page
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text('Back', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
