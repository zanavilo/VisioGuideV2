import 'package:flutter/material.dart';
import 'package:visioguide/Pages/MainPage.dart';

class InfoSlider extends StatefulWidget {
  @override
  _InfoSliderState createState() => _InfoSliderState();
}

class _InfoSliderState extends State<InfoSlider> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('App Information')),
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page; // Update the current page index
              });
            },
            children: [
              // Define each page with content
              InfoPage(
                imagePath: 'assets/info1.png',
                title: 'Welcome to Visio-Guide',
                description: 'Visio-Guide helps visually impaired users navigate their surroundings with ease.',
              ),
              InfoPage(
                imagePath: 'assets/info2.png',
                title: 'Read Text',
                description: 'Use the camera to read text in your environment quickly and efficiently.',
              ),
              InfoPage(
                imagePath: 'assets/info3.png',
                title: 'Object Detection',
                description: 'Detect objects around you using cutting-edge technology.',
              ),
              InfoPage(
                imagePath: 'assets/info4.png',
                title: 'Stay Informed',
                description: 'Get weather updates, battery status, and more to stay informed wherever you are.',
              ),
            ],
          ),
          // Conditionally show the 'Go to Main Page' button on the last page
          if (_currentPage == 3) // Index 3 is the last page (0-based index)
            Positioned(
              bottom: 20.0,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Use Navigator.pushReplacement to navigate to MainPage
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MainPage()),
                    );
                  },
                  child: const Text('Go to Main Page'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Define the InfoPage widget to take in image, title, and description as parameters
class InfoPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const InfoPage({
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Display the image for each slide
          Image.asset(
            imagePath,
            height: 200, // Adjust height as necessary
          ),
          const SizedBox(height: 20),
          // Display the title for each slide
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          // Display the description for each slide
          Text(
            description,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
