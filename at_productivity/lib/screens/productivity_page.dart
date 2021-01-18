import 'package:atproductivity/components/app_header.dart';
import 'package:atproductivity/components/icon_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Represents the productivity page of the app
class ProductivityPage extends StatefulWidget {
  /// ID of ProductivityPage in main.dart
  static final String id = 'productivity';
  @override
  _ProductivityPageState createState() => _ProductivityPageState();
}

class _ProductivityPageState extends State<ProductivityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context),
      backgroundColor: Color(0XFF13505B),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
              'Let\'s get Productive',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 36,
                color: Colors.white,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                AnIconButton(
                  image: 'assets/images/lumberjack.png',
                  title: 'Lumberjack',
                  height: MediaQuery.of(context).size.width / 3,
                ),
                AnIconButton(
                  image: 'assets/images/tree.png',
                  title: 'Grow a tree',
                  height: MediaQuery.of(context).size.width / 3,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                AnIconButton(
                  image: 'assets/images/fireplace.png',
                  title: 'Fireplace',
                  height: MediaQuery.of(context).size.width / 3,
                ),
                AnIconButton(
                  image: 'assets/images/desk.png',
                  title: 'Studying',
                  height: MediaQuery.of(context).size.width / 3,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
