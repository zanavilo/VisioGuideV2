import 'dart:async';
import 'package:flutter/material.dart';
import 'package:visioguide/Pages/MainPage.dart';
//tang ina ni moce
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice Command App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(), // Splash screen route
        '/MainPage': (context) => MainPage(), // Navigate to mainPage after splash
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  double _opacity = 0.0; // Initial opacity set to 0 for fade-in
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Start the fade-in animation
    _controller = AnimationController(
      duration: const Duration(seconds: 3), // Total duration for fade-in and hold
      vsync: this,
    );

    // Set the opacity to 1.0 after a small delay (fade-in)
    Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0; // Fade-in opacity
      });
    });

    // Navigate to the main page with a fade-out effect after the splash screen
    Timer(const Duration(seconds: 3), () {
      setState(() {
        _opacity = 0.0; // Start fade-out
      });
      Timer(const Duration(milliseconds: 500), () {
        Navigator.of(context).pushReplacementNamed('/MainPage');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Background color of the splash screen
      body: AnimatedOpacity(
        opacity: _opacity, // Apply opacity
        duration: const Duration(milliseconds: 500), // Duration for fade-in and fade-out
        child: Center(
          child: Image.asset('assets/logo.png'), // Splash logo image
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Stack(
        children: <Widget>[
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/wallpaper.jpg"), // Background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content in the foreground
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'You have pushed the button this many times:',
                ),
                Text(
                  '$_counter',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
