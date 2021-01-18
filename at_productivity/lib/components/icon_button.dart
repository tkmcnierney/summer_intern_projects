import 'package:atproductivity/Productivity/timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Represents a placeholder image on "Productivity" route
class AnIconButton extends StatelessWidget {
  // The URL to the placeholder image
  final String image;
  // Represents the name of the activity
  final String title;
  // The desired height of the button
  final double height;

  AnIconButton({this.image, this.title, this.height});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Center(
        child: Column(
          children: <Widget> [
            MaterialButton(
              onPressed: () {
                Navigator.pushNamed(context, ProductivityTimer.id);
              },
              height: this.height,
              child: CircleAvatar(
                radius: this.height / 2,
                backgroundImage: AssetImage(
                  this.image,
                ),
                backgroundColor: Color(0XFF7D83FF),
              )
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(
                this.title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}