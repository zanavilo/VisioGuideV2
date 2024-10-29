import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final String text;

  ResultScreen({required this.text});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recognized Text'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            text.isNotEmpty ? text : 'No text recognized.',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.justify,
          ),
        ),
      ),
    );
  }
}
