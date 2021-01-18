import 'package:atproductivity/components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:atproductivity/constants.dart';
import 'home_page.dart';

/// Represents the login page a user is directed to
class LoginPage extends StatefulWidget {
  /// ID of LoginPage in main.dart
  static final String id = 'login';
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool setSpinner = false;
  // User's email address
  String email;
  // User's password
  String password;
  // An error message if it forms
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: setSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Container(
                  height: 200.0,
                  child: Image.asset('assets/images/man.png'),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                decoration: textFieldDecoration.copyWith(
                  hintText: 'Enter your email',
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration: textFieldDecoration.copyWith(
                  hintText: 'Enter your password',
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  error,
                  style: TextStyle(
                    color: Colors.redAccent,
                  ),
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                color: Colors.lightBlueAccent,
                route: () async {
                  setState(() {
                    setSpinner = true;
                  });
                  try {
                    final returningUser = await _auth.signInWithEmailAndPassword(
                        email: email, password: password);
                    if (returningUser != null) {
                      Navigator.pushNamed(context, HomePage.id);
                      setState(() {
                        error = '';
                        setSpinner = false;
                      });
                    }
                  } catch (e) {
                    print(e);
                    setState(() {
                      error = 'Your login information is incorrect/invalid';
                      setSpinner = false;
                    });
                  }
                },
                title: 'Log In',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
