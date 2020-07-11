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
  int time1Hour, time1Min, time2Hour, time2Min = 0;
  String time1, time2 = "";
  DateTime diffTime;

  TimeOfDay _time = new TimeOfDay.now();
  String showTime = 'HH:MM';
  bool manualOverride = false;

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
    time1 = _currentTime(hour: defaultHour, min: defaultMin);
    time2 = _currentTime(hour: secondHour, min: secondMin);
  }

  _currentTime({int hour, int min}) {
    Duration duration = new Duration(hours: hour, minutes: min);
    DateTime dateTime = DateTime.now().toUtc().add(duration);
    return _fixTime(hour: dateTime.hour, min: dateTime.minute);
//    return "${dateTime.hour} : ${dateTime.minute}";
  }

  getHour({int hour, int min}) {
    Duration duration = new Duration(hours: hour, minutes: min);
    DateTime dateTime = DateTime.now().toUtc().add(duration);
    return dateTime.hour;
  }

  getMin({int hour, int min}) {
    Duration duration = new Duration(hours: hour, minutes: min);
    DateTime dateTime = DateTime.now().toUtc().add(duration);
    return dateTime.minute;
  }

  convertTimetoDouble(String time) {
    List<String> value = time.split(':');
    return (double.parse(value[0]) + double.parse(value[1]) / 60);
  }

  addTime(String t1, String t2) {
    double time = convertTimetoDouble(t1) + convertTimetoDouble(t2);
    int tHour = time.truncate();
    int tMin = ((time - time.truncate()) * 60).toInt();
    return _fixTime(hour: tHour, min: tMin);
  }

  _fixTime({int hour, int min}) {
    return "${hour.toString().padLeft(2, '0')} : ${min.toString().padLeft(2, '0')}";
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
    time1 = _currentTime(hour: defaultHour, min: defaultMin);
    time2 = _currentTime(hour: secondHour, min: secondMin);
    showTime = _currentTime(hour: defaultHour, min: defaultMin);
    print('Reset time to ${showTime}');
    manualOverride = false;
  }

  Future<Null> selectTime(BuildContext context, String tInstance) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (picked != null && picked != _time) {
      print('Time selected : ${picked.toString()}');
      try {
        setState(() {
          pickedHour = picked.hour;
          pickedMin = picked.minute;
          manualOverride = true;

          //diff two TimeOfDay TODO: make it function
          double _doublePickedTime =
              picked.hour.toDouble() + (picked.minute.toDouble() / 60);
          double _doubleCurrentTime = 0.0;
          if (tInstance == 't1') {
            _doubleCurrentTime = convertTimetoDouble(time1);
          } else {
            _doubleCurrentTime = convertTimetoDouble(time2);
          }

          double _timeDiff = _doublePickedTime - _doubleCurrentTime;
          print('timeDiff:' + _timeDiff.toString());
          diffHour = _timeDiff.truncate();
          diffMin = ((_timeDiff - _timeDiff.truncate()) * 60).toInt();

          print('Time difference: $diffHour Hour and $diffMin min');
          //TODO: Fix the precise time difference.

          //Set the time difference to the clock
          time1 = addTime(time1, _fixTime(hour: diffHour, min: diffMin));
          time2 = addTime(time2, _fixTime(hour: diffHour, min: diffMin));
        });
      } catch (e, s) {
        print(s);
      }
    }
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
//                          ? _fixTime(hour: )
                              ? time1
                              : _currentTime(
                                  hour: defaultHour,
                                  min: defaultMin,
                                ),
//                              : _currentTime(
//                                  hour: defaultHour, min: defaultMin),
                          style: TextStyle(fontSize: 100.0),
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
                    selectTime(context, 't1');
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
                              ? time2
//                              : _currentTime(hour: secondHour, min: secondMin),
                              : _currentTime(
                                  hour: secondHour,
                                  min: secondMin,
                                ),
                          style: TextStyle(fontSize: 100.0),
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
                  onPress: () {
                    selectTime(context, 't2');
                  },
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
