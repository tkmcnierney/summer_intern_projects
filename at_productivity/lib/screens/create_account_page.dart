import 'dart:async';
import 'package:atproductivity/components/app_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import '../constants.dart';

/// Represents the route that is displayed when creating an account
class CreateAccountPage extends StatefulWidget {
  /// ID of CreateAccountPage in main.dart
  static final String id = 'create_account';
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  // A parameter to be passed into Scaffold
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  // Determines state of the Form
  final _formKey = GlobalKey<FormState>();
  // Determines whether or not to display the spinning icon
  bool showSpinner = false;
  // The inputted username
  String username;

  /// Redirects to main feed if _formKey is valid
  void submitUserName() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
            content: Text("Welcome $username")
        )
      );
      Timer(Duration(seconds: 4), () {
        // After 4 seconds, redirect to main feed
        Navigator.pop(context, username);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: header(context, isAppTitle: false, strTitle: "Create Account"),
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 48.0,
              ),
              Form(
                key: _formKey,
                autovalidate: true,
                child: TextFormField(
                  validator: (val) {
                    if (val.trim().length < 5 || val.isEmpty) {
                      return 'username is too short';
                    } else if (val.trim().length > 15) {
                      return 'username is too long';
                    } else if (val[0] != '@') {
                      return 'username does not begin with @';
                    } else {
                      return null;
                    }
                  },
                  onSaved: (val) => username = val,
                  decoration: textFieldDecoration.copyWith(
                    labelText: 'username',
                    hintText: 'Must begin with @ and contain 5-15 characters',
                  ),
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 25),
                child: Material(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30.0),
                  elevation: 5.0,
                  child: MaterialButton(
                    onPressed: () {
                      submitUserName();
                    },
                    height: 65.0,
                    child: Text(
                    'Proceed',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
