import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  final List<Option> options = [
    Option('READ', 'Read the text using camera', Icons.book),
    Option('OBJECT DETECTION', 'Detect the object', Icons.search),
    Option('CALCULATOR', 'Perform mathematical calculations', Icons.calculate),
    Option('WEATHER', 'Get weather details', Icons.wb_sunny),
    Option('NAVIGATION', 'Navigate to the destination', Icons.navigation),
    Option('BATTERY', 'Get battery percentage', Icons.battery_std),
    Option('TIME AND DATE', 'Get time and date', Icons.access_time),
    Option('BACK', 'Return to Home screen', Icons.arrow_back),
    Option('EXIT', 'Close the application', Icons.exit_to_app),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Command App'),
      ),
      body: Stack(
        children: <Widget>[
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/wallpaper.jpg"), // Ensure this image is in your assets
                fit: BoxFit.cover,
              ),
            ),
          ),
          // ListView with options
          ListView.builder(
            itemCount: options.length,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  leading: Icon(options[index].icon, size: 40),
                  title: Text(
                    'Say ${options[index].title}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  subtitle: Text(options[index].description),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${options[index].title} selected'),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class Option {
  final String title;
  final String description;
  final IconData icon;

  Option(this.title, this.description, this.icon);
}
