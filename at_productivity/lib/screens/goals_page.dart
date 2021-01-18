import 'package:atproductivity/components/app_header.dart';
import 'package:atproductivity/components/icon_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Represents the Goals route in the app
///
/// This page is very much incomplete
class GoalsPage extends StatefulWidget {
  /// ID of GoalsPage in main.dart
  static final String id = 'goals';
  @override
  _GoalsPageState createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context),
      backgroundColor: Color(0XFF0B3447),
      body: Center(
        child: SafeArea(
          child: Column(
            children: <Widget> [
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Card(
                  color: Color(0XFF3B6F99),
                  child: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Set a Goal',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 36,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        // TODO: Replace static images with goal-setting functionality
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            AnIconButton(
                              image: 'assets/images/lumberjack.png',
                              title: 'Lumberjack',
                              height: MediaQuery.of(context).size.width / 6,
                            ),
                            AnIconButton(
                              image: 'assets/images/tree.png',
                              title: 'Grow a tree',
                              height: MediaQuery.of(context).size.width / 6,
                            ),
                            AnIconButton(
                              image: 'assets/images/tree.png',
                              title: 'Grow a tree',
                              height: MediaQuery.of(context).size.width / 6,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            AnIconButton(
                              image: 'assets/images/fireplace.png',
                              title: 'Fireplace',
                              height: MediaQuery.of(context).size.width / 6,
                            ),
                            AnIconButton(
                              image: 'assets/images/desk.png',
                              title: 'Studying',
                              height: MediaQuery.of(context).size.width / 6,
                            ),
                            AnIconButton(
                              image: 'assets/images/desk.png',
                              title: 'Studying',
                              height: MediaQuery.of(context).size.width / 6,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Card(
                  color: Color(0XFF3B6F99),
                  child: Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Update my Goals',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 36,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
