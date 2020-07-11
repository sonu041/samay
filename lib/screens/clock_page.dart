import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:samay/components/reusable_card.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ClockPage extends StatefulWidget {
  @override
  _ClockPageState createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  double seconds; //Not using now but can be used later.
  int defaultHour = 5;
  int defaultMin = 30;
  int secondHour = -4;
  int secondMin = 0;
  int diffHour, diffMin, pickedHour, pickedMin = 0;
  DateTime diffTime;

  TimeOfDay _time = new TimeOfDay.now();
  String showTime = 'HH:MM';
  bool manualOverride = false;

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

  _resetTime() {
    showTime = _currentTime(hour: defaultHour, min: defaultMin);
    print('Reset time to ${showTime}');
    manualOverride = false;
  }

  Future<Null> selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null && picked != _time) {
      print('Time selected : ${picked.toString()}');
      setState(() {
        //_time = picked;
        pickedHour = picked.hour;
        pickedMin = picked.minute;
        showTime = "${picked.hour} : ${picked.minute}";
        manualOverride = true;
        //TimeOfDay.fromDateTime(DateTime.now()) - picked;

        //diff two TimeOfDay TODO: make it function
        double _doubleCurrentTime = DateTime.now().hour.toDouble() +
            (DateTime.now().minute.toDouble() / 60);
        double _doublePickedTime =
            picked.hour.toDouble() + (picked.minute.toDouble() / 60);

        double _timeDiff = _doublePickedTime - _doubleCurrentTime;
        print('timeDiff:' + _timeDiff.toString());
        diffHour = _timeDiff.truncate();
        diffMin = ((_timeDiff - _timeDiff.truncate()) * 60).toInt();

        print('Time difference: $diffHour Hour and $diffMin min');
        //TODO: Fix the precise time difference.

//        Duration difference = picked
        //diffTime = picked - _current
        // Time(hour: defaultHour, min: defaultMin);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    seconds = DateTime.now().second / 60;
    _triggerUpdate();
    print('Init called');
    //_setupTime();
    showTime = _currentTime(hour: defaultHour, min: defaultMin);
    diffHour = DateTime.now().hour - defaultHour;
    diffMin = DateTime.now().minute - defaultMin;
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Text(
                          //_currentTime(hour: defaultHour, min: defaultMin),
                          manualOverride
                              ? _currentTime(
                                  hour: defaultHour + diffHour,
                                  min: defaultMin + diffMin)
                              : _currentTime(
                                  hour: defaultHour, min: defaultMin),
                          style: TextStyle(fontSize: 100.0),
//                          style: GoogleFonts.bungee(
//                              fontSize: 100.0,
//                              textStyle: TextStyle(color: Colors.white),
//                              fontWeight: FontWeight.normal),
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
                  onPress: () {
                    selectTime(context);
                  },
                  colour: Color(0xFF1D1E33),
                ),
              ),
              Expanded(
                child: ReusableCard(
                  cardChild: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Text(
                          manualOverride
                              ? _currentTime(
                                  hour: secondHour + diffHour,
                                  min: secondMin + diffMin)
                              : _currentTime(hour: secondHour, min: secondMin),

                          style: TextStyle(fontSize: 100.0),
//                          style: GoogleFonts.bungee(
//                              fontSize: 100.0,
//                              textStyle: TextStyle(color: Colors.white),
//                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      Center(
                        child: Text(
                          'USA (ET)',
                          style: TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ],
                  ),
                  colour: Color(0xFF1D1E33),
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              LinearPercentIndicator(
                percent: seconds,
                lineHeight: 15.0,
                center: Text(
                  (seconds * 60).toInt().toString(),
                  style: new TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
//                lineHeight: 14.0,
              ),
              SizedBox(
                height: 40.0,
              ),
              FloatingActionButton(
                onPressed: () {
                  // Add your onPressed code here!
                  setState(() {
                    _resetTime();
                  });
                },
                child: Icon(Icons.refresh),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              Container(
                child: Container(
                  height: 100.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
