import 'package:atproductivity/Productivity/timer.dart';
import 'package:atproductivity/screens/comments_page.dart';
import 'package:atproductivity/screens/create_account_page.dart';
import 'package:atproductivity/screens/feed.dart';
import 'package:atproductivity/screens/friends_page.dart';
import 'package:atproductivity/screens/goals_page.dart';
import 'package:atproductivity/screens/home_page.dart';
import 'package:atproductivity/screens/login_page.dart';
import 'package:atproductivity/screens/productivity_page.dart';
import 'package:atproductivity/screens/profile_page.dart';
import 'package:atproductivity/screens/registration_page.dart';
import 'package:atproductivity/screens/upload_page.dart';
import 'package:atproductivity/screens/welcome_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: WelcomePage.id,
      routes: {
        WelcomePage.id: (context) => WelcomePage(),
        RegistrationPage.id: (context) => RegistrationPage(),
        LoginPage.id: (context) => LoginPage(),
        HomePage.id: (context) => HomePage(),
        CreateAccountPage.id: (context) => CreateAccountPage(),
        Feed.id: (context) => Feed(),
        FriendsPage.id: (context) => FriendsPage(),
        GoalsPage.id: (context) => GoalsPage(),
        ProductivityPage.id: (context) => ProductivityPage(),
        ProfilePage.id: (context) => ProfilePage(),
        ProductivityTimer.id: (context) => ProductivityTimer(),
        UploadPage.id: (context) => UploadPage(),
      },
    );
  }
}