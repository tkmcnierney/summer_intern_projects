import 'dart:async';

import 'package:atproductivity/components/timer_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

/// Represents the route with the timer in the Productivity page
class ProductivityTimer extends StatefulWidget {
  /// ID of ProductivityTimer in main.dart
  static final String id = 'timer';
  @override
  _ProductivityTimerState createState() => _ProductivityTimerState();
}

class _ProductivityTimerState extends State<ProductivityTimer> {
  // Hour value of the timer
  int _hourValue = 0;
  // Minute value of the timer
  int _minuteValue = 0;
  // Indicates whether we've started the timer
  bool started = true;
  // Indicates whether we've stopped the timer
  bool stopped = true;
  // The number of seconds that have elapsed
  int timeForTimer = 0;
  // The text to be displayed on the timer
  RichText timeToDisplay;
  // Indicates whether or not to cancel the timer
  bool checkTimer = true;
  // Indicates if it is the user's first click
  bool firstClick = true;

  /// Assigns a new value to _hourValue
  void hourOnChanged(num hour) {
    setState(() {
      _hourValue = hour;
    });
  }

  /// Assigns a new value to _minuteValue
  void minuteOnChanged(num minute) {
    setState(() {
      _minuteValue = minute;
    });
  }

  /// Reveals the timer to the user
  Widget timerText(int hours, int minutes, int seconds) {
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: hours.toString(),
            style: TextStyle(
              color: Colors.grey,
              fontSize: 50,
            ),
          ),
          TextSpan(
            text: hours == 1 ? " hour  "
                : " hours  ",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 18,
            ),
          ),
          TextSpan(
            text: minutes < 10 ? '0' + minutes.toString()
                : minutes.toString(),
            style: TextStyle(
              color: Colors.grey,
              fontSize: 50,
            ),
          ),
          TextSpan(
            text: minutes == 1 ? " minute  "
                : " minutes  ",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 18,
            ),
          ),
          TextSpan(
            text: seconds < 10 ? '0' + seconds.toString()
                : seconds.toString(),
            style: TextStyle(
              color: Colors.grey,
              fontSize: 50,
            ),
          ),
          TextSpan(
            text: seconds == 1 ? " second  "
                : " seconds  ",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  /// Updates variables when the timer is reset
  void resetTimer() {
    checkTimer = true;
    started = true;
    stopped = true;
    firstClick = true;
    timeToDisplay = timerText(0, 0, 0);
    _hourValue = 0;
    _minuteValue = 0;
  }

  /// Starts the timer
  void startTimer() {
    setState(() {
      started = false;
      stopped = false;
      checkTimer = true;
    });
    // Initialize timeForTimer if it is the firstClick
    if (firstClick) {
      timeForTimer = _hourValue * 3600 + _minuteValue * 60;
    }
    Timer.periodic(
        Duration(
            seconds: 1
        ), (Timer timer) {
      if (!mounted) {
        return;
      } else {
          setState(() {
            firstClick = false;
            if (checkTimer == false) {
              timer.cancel();
              return;
            } else if (timeForTimer < 1) {
              timer.cancel();
              resetTimer();
              return;
            } else if (timeForTimer < 60) {
              timeToDisplay = timerText(0, 0, timeForTimer);
            } else if (timeForTimer < 3600) {
              int m = timeForTimer ~/ 60;
              int s = timeForTimer - m * 60;
              timeToDisplay = timerText(0, m, s);
            } else {
              int h = timeForTimer ~/ 3600;
              int m = (timeForTimer - 3600 * h) ~/ 60;
              int s = (timeForTimer - 3600 * h) - m * 60;
              timeToDisplay = timerText(h, m, s);
            }
            timeForTimer--;
          });
        }
      }
    );
  }

  /// Stops the timer
  void stopTimer() {
    setState(() {
      started = true;
      stopped = true;
      checkTimer = false;
    });
  }

  /// Represents the timer widget
  Widget timer() {
    return Center(
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Text(
                          'Hours',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0XFF13505B),
                          ),
                        ),
                      ),
                      NumberPicker.integer(
                          initialValue: _hourValue,
                          minValue: 0,
                          maxValue: 2,
                          onChanged: hourOnChanged,
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Text(
                          'Minutes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0XFF13505B),
                          ),
                        ),
                      ),
                      NumberPicker.integer(
                        initialValue: _minuteValue,
                        minValue: 0,
                        maxValue: 55,
                        step: 5,
                        onChanged: minuteOnChanged,
                      ),
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              flex: 6,
              child: Image(
                image: AssetImage(
                  'assets/images/man.png',
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: firstClick ? timerText(_hourValue,
                  _minuteValue, 0)
                  : timeToDisplay,
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: TimerButton(
                      color: Color(0XFF13505B),
                      function: () {
                        if (started) {
                          startTimer();
                        } else {
                          return null;
                        }
                      },
                      title: 'Start',
                    ),
                  ),
                  Expanded(
                    child: TimerButton(
                      color: Colors.redAccent,
                      function: () {
                        if (stopped) {
                          return null;
                        } else {
                          stopTimer();
                        }
                      },
                      title: 'Stop',
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    checkTimer = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: timer(),
    );
  }
}
