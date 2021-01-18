import 'package:atproductivity/components/rounded_button.dart';
import 'package:atproductivity/screens/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../constants.dart';

/// Represents the registration screen that a user is directed to
class RegistrationPage extends StatefulWidget {
  /// ID of RegistrationPage in main.dart
  static final String id = 'register';
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  // Request the user to re-enter password
  String confirmPassword;
  bool showSpinner = false;
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Flexible widget will keep widgets on screen for different devices.
              Flexible(
                // Match Hero tag with the Hero tag in welcome_screen.dart
                // to complete the animation. The different Container heights
                // trigger the animation.
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
                // Obscure the password.
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration: textFieldDecoration.copyWith(
                  hintText: 'Enter your password',
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                // Obscure the password.
                obscureText: true,
                onChanged: (value) {
                  confirmPassword = value;
                },
                decoration: textFieldDecoration.copyWith(
                  hintText: 'Re-enter your password',
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
                color: Colors.blueAccent,
                route: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  if (password == confirmPassword) {
                    try {
                      final newUser = await _auth
                          .createUserWithEmailAndPassword(
                          email: email, password: password);
                      if (newUser != null) {
                        Navigator.pushNamed(context, HomePage.id);
                      }
                      setState(() {
                        error = '';
                        showSpinner = false;
                      });
                    } catch (e) {
                      print(e);
                      setState(() {
                        error = 'Invalid email or password '
                            '(password must be at least six characters)';
                        showSpinner = false;
                      });
                    }
                  } else {
                    setState(() {
                      error = 'Password does not match';
                      showSpinner = false;
                    });
                  }
                },
                title: 'Register',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
