import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A simple class for a rounded MaterialButton
class RoundedButton extends StatelessWidget {
  // Desired color of the button
  final Color color;
  // Destination of the button
  final Function route;
  // The text to accompany the button
  final String title;

  RoundedButton({this.color, this.route, this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 25),
      child: Material(
        color: this.color,
        borderRadius: BorderRadius.circular(30.0),
        elevation: 5.0,
        child: MaterialButton(
          onPressed: this.route,
          height: 65.0,
          child: Text(
            this.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}