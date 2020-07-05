import 'package:flutter/material.dart';

import 'screens/clock_page.dart';

void main() => runApp(Samay());

class Samay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF0A0E21),
        scaffoldBackgroundColor: Color(0xFF0A0E21),
      ),
      home: ClockPage(),
    );
  }
}
