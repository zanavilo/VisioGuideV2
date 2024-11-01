import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:visioguide/Pages/MainPage.dart';

class InfoSlider extends StatefulWidget {
  @override
  _InfoSliderState createState() => _InfoSliderState();
}

class _InfoSliderState extends State<InfoSlider> {
  late Future<bool> _isOnboardingSeen;
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _isOnboardingSeen = _checkIfOnboardingSeen();
  }

  Future<bool> _checkIfOnboardingSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('onboarding_seen') ?? false;
  }

  Future<void> _setOnboardingSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_seen', true);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _isOnboardingSeen,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.blue,
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.data == true) {
          // Directly navigate to MainPage if onboarding has been seen
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainPage()),
            );
          });
          return Scaffold(); // Prevent flickering
        } else {
          // Onboarding flow for new users
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Application Information',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.blue,
            ),
            body: Stack(
              children: <Widget>[
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
                      _currentPage = page;
                    });
                  },
                  children: [
                    InfoPage(
                      title: 'Welcome to Visio-Guide',
                      description: 'Discover Visio-Guide, your essential companion...',
                      isWelcomePage: true,
                    ),
                    InfoPage(
                      imagePath: 'assets/features.png',
                      title: 'Innovative Technology',
                      description: 'Leveraging cutting-edge technology...',
                    ),
                    InfoPage(
                      imagePath: 'assets/safety.png',
                      title: 'Your Safety, Our Priority',
                      description: 'With features designed to keep you informed and safe...',
                    ),
                    InfoPage(
                      imagePath: 'assets/greet.png',
                      title: 'Get Started!',
                      description: 'Start using Visio-Guide by going to the Main Page...',
                    ),
                    InfoPage(
                      imagePath: 'assets/blind.png',
                      title: 'New User? Welcome!',
                      description: 'We are thrilled to have you! Explore the features...',
                    ),
                  ],
                ),
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
                if (_currentPage == 4)
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
                            onPressed: () async {
                              await _setOnboardingSeen();
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
      },
    );
  }
}

class InfoPage extends StatelessWidget {
  final String title;
  final String description;
  final String? imagePath;
  final bool isWelcomePage;

  const InfoPage({
    Key? key,
    required this.title,
    required this.description,
    this.imagePath,
    this.isWelcomePage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (imagePath != null)
            Image.asset(imagePath!, height: 200),
          SizedBox(height: 20),
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

