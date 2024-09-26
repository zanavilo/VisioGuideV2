import 'package:flutter/material.dart';

class NavigationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Navigation'),
      ),
      body: Center(
        child: Text(
          'This is the page for navigation to a destination.',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
