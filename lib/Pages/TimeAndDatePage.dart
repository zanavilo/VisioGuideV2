import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class TimeAndDatePage extends StatefulWidget {
  @override
  _TimeAndDatePageState createState() => _TimeAndDatePageState();
}

class _TimeAndDatePageState extends State<TimeAndDatePage> {
  late String formattedDate;

  @override
  void initState() {
    super.initState();
    _updateTime();
    Timer.periodic(Duration(seconds: 1), (Timer t) => _updateTime());
  }

  void _updateTime() {
    DateTime now = DateTime.now();
    setState(() {
      formattedDate = DateFormat('yyyy-MM-dd – kk:mm:ss').format(now);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Date and Time Example"),
      ),
      body: Center(
        child: Text(
          formattedDate,
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
