import 'package:atproductivity/components/rounded_button.dart';
import 'package:atproductivity/screens/registration_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';

/// The first route that appears before a user
class WelcomePage extends StatefulWidget {
  /// ID of WelcomePage in main.dart
  static final String id = 'welcome';
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFAEE5D8),
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 70.0, horizontal: 20),
                child: Text(
                  'Welcome to @Productivity',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: Color(0XFF302F35),
                  ),
                ),
              ),
              Image.asset(
                'assets/images/man.png',
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 50.0),
                child: Text(
                  'Your world, a little more productive',
                  style: TextStyle(
                    color: Color(0XFF13505B),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: RoundedButton(
                  color: Color(0XFF7D83FF),
                  route: () {
                    Navigator.pushNamed(context,
                        LoginPage.id);
                  },
                  title: '@handle sign in',
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: RoundedButton(
                  color: Color(0XFF7D83FF),
                  route: () {
                    Navigator.pushNamed(context,
                        RegistrationPage.id);
                  },
                  title: 'Register an @handle',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
