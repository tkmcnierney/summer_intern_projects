import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A simple class for the start and stop of the Timer screen
class TimerButton extends StatelessWidget {
  // Desired color of the button
  final Color color;
  // The function to be executed on the button press
  final Function function;
  // The text to accompany the button
  final String title;

  TimerButton({this.color, this.function, this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 15.0),
      child: Material(
        color: this.color,
        borderRadius: BorderRadius.circular(30.0),
        elevation: 5.0,
        child: MaterialButton(
          onPressed: this.function,
          height: 35.0,
          child: Text(
            this.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }
}