import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visioguide/Pages/MainPage.dart';

class InfoSlider extends StatefulWidget {
  @override
  _InfoSliderState createState() => _InfoSliderState();
}

class _InfoSliderState extends State<InfoSlider> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _checkIfOnboardingSeen();
  }

  Future<void> _checkIfOnboardingSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? seen = prefs.getBool('onboarding_seen');

    // If seen is true, navigate to MainPage
    if (seen == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    }
  }

  Future<void> _setOnboardingSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_seen', true);
  }

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
                image: AssetImage("assets/wpg.png"),
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
              InfoPage(
                imagePath: 'assets/new_user.png',
                title: 'New User? Welcome!',
                description: 'We are thrilled to have you! Explore the features, and let Visio-Guide assist you in navigating your surroundings safely and effectively.',
              ),
            ],
          ),
          // Page indicator dots
          Positioned(
            bottom: 80.0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
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
          if (_currentPage == 4) // Updated for the new last page
            Positioned(
              bottom: 20.0,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        textStyle: const TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        _setOnboardingSeen(); // Set the flag to true
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => MainPage()),
                        );
                      },
                      child: const Text('Go to Main Page'),
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
          Image.asset(imagePath, height: 200),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(fontSize: 16, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
