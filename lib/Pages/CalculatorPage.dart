import 'package:flutter/material.dart';

class CalculatorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
      ),
      body: Center(
        child: Text(
          'This is the page for performing mathematical calculations.',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
