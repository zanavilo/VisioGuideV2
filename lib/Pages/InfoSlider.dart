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
      appBar: AppBar(
        title: const Text('Application Information', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
      ),
      body: Stack(
        children: <Widget>[
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/wpg.png"), // Ensure this image is in your assets
                fit: BoxFit.cover,
              ),
            ),
          ),
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
                imagePath: 'assets/eye.png',
                title: 'Welcome to Visio-Guide',
                description: 'Discover Visio-Guide, your essential companion for navigating the world with ease. This app is specifically designed to empower visually impaired individuals by providing useful tools for mobility and awareness.',
              ),
              InfoPage(
                imagePath: 'assets/features.png',
                title: 'Innovative Technology',
                description: 'Leveraging cutting-edge technology, Visio-Guide incorporates features such as real-time text reading and advanced object detection, transforming how users interact with their environment.',
              ),
              InfoPage(
                imagePath: 'assets/safety.png',
                title: 'Your Safety, Our Priority',
                description: 'With features designed to keep you informed and safe, Visio-Guide is dedicated to providing reliable assistance, ensuring you feel secure in every step you take.',
              ),
              InfoPage(
                imagePath: 'assets/greet.png',
                title: 'Get Started!',
                description: 'Start using Visio-Guide by going to the Main Page and simply saying "SAY" then the feature you want to use.',
              ),
            ],
          ),
          // Page indicator dots
          Positioned(
            bottom: 80.0, // Position above the button
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  height: 8.0,
                  width: 8.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index ? Colors.blue : Colors.grey,
                  ),
                );
              }),
            ),
          ),
          // Conditionally show the 'Go to Main Page' button on the last page
          if (_currentPage == 3) // Index 3 is the last page (0-based index)
            Positioned(
              bottom: 20.0,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: double.infinity, // Make the button width dynamic (like in PrivacyAndTerms.dart)
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0), // Adjust padding to make the button size similar
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,    // Button background color
                        foregroundColor: Colors.white, // Button text color
                        padding: const EdgeInsets.symmetric(vertical: 15.0), // Similar button height
                        textStyle: const TextStyle(fontSize: 18), // Font size for text inside button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10), // Rounded corners
                        ),
                      ),
                      onPressed: () {
                        // Use Navigator.pushReplacement to navigate to MainPage
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => MainPage()),
                        );
                      },
                      child: const Text('Go to Main Page'), // Button text
                    ),
                  ),
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
          Image.asset(imagePath, height: 200, // Adjust height as necessary
          ),
          const SizedBox(height: 20),
          // Display the title for each slide
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          // Display the description for each slide
          Text(
            description,
            style: const TextStyle(fontSize: 16, color: Colors.white
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
