import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samay/components/reusable_card.dart';

class ClockPage extends StatefulWidget {
  @override
  _ClockPageState createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  double seconds; //Not using now but can be used later.
  int defaultHour = 5;
  int defaultMin = 30;

  _currentTime({int hour, int min}) {
    Duration duration = new Duration(hours: hour, minutes: min);
    DateTime dateTime = DateTime.now().toUtc().add(duration);
    return "${dateTime.hour} : ${dateTime.minute}";
  }

  _triggerUpdate() {
    Timer.periodic(
      Duration(seconds: 1),
      (Timer timer) => setState(
        () {
          seconds = DateTime.now().second / 60;
          //print(seconds);
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    seconds = DateTime.now().second / 60;
    _triggerUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time'),
      ),
      body: Center(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: ReusableCard(
                  cardChild: Column(
                    children: <Widget>[
                      Center(
                        child: Text(
                          _currentTime(hour: defaultHour, min: defaultMin),
                          style: GoogleFonts.bungee(
                              fontSize: 100.0,
                              textStyle: TextStyle(color: Colors.white),
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      Center(
                        child: Text(
                          'India (IST)',
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ],
                  ),
                  colour: Color(0xFF1D1E33),
                ),
              ),
              Expanded(
                child: ReusableCard(
                  cardChild: Column(
                    children: <Widget>[
                      Center(
                        child: Text(
                          _currentTime(hour: defaultHour, min: defaultMin),
                          style: GoogleFonts.bungee(
                              fontSize: 100.0,
                              textStyle: TextStyle(color: Colors.white),
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      Center(
                        child: Text(
                          'USA (EST)',
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ],
                  ),
                  colour: Color(0xFF1D1E33),
                ),
              ),
              Expanded(
                child: ReusableCard(
                  cardChild: Text('Time2'),
                  colour: Color(0xFF1D1E33),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
