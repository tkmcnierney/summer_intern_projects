import 'package:atproductivity/components/app_header.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';

/// Represents the profile section of the app
///
/// Very incomplete
class ProfilePage extends StatefulWidget {
  /// ID of ProfilePage in main.dart
  static final String id = 'profile';
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context),
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Image(
                image: AssetImage(
                'assets/images/man.png',
                ),
                height: 250,
                width: 250,
              ),
            ),
            Expanded(
              flex: 5,
              child: Text(
                currentUser == null ? '' : currentUser.username,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: SizedBox(
                child: MaterialButton(
                  onPressed: () {
                    _auth.signOut();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  color: Colors.redAccent,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
