import 'package:atproductivity/components/current_user.dart';
import 'package:atproductivity/screens/create_account_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'feed.dart';
import 'friends_page.dart';
import 'goals_page.dart';
import 'productivity_page.dart';
import 'profile_page.dart';

// These variables are references for all other classes that
// contain the various collections existing in Firebase
final usersReference = Firestore.instance.collection('users');
final postsReference = Firestore.instance.collection('posts');
final StorageReference storageReference = FirebaseStorage.instance.ref().child('Posts Pictures');
final activityFeedReference = Firestore.instance.collection('feed');
final commentsReference = Firestore.instance.collection('comments');
final groupReference = Firestore.instance.collection('group');

// the currently logged-in user
FirebaseUser loggedInUser;
// Same as above except structured more conveniently in a custom class
CurrentUser currentUser;

/// The "HomePage" of the app. It isn't necessarily a route
///
/// but rather determines which route to display
class HomePage extends StatefulWidget {
  /// ID of HomePage in main.dart
  static final String id = 'home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = FirebaseAuth.instance;
  // The index that represents a route on the HomePage
  int _selectedIndex = 0;
  PageController pageController;
  // Timestamp for if the account was created for the first time
  final Timestamp timestamp = Timestamp.now();

  /// Retrieve the logged-in user
  void getCurrentUser() async {
    try {
      // Null if no one is signed in. If someone is registered, not null.
      final user = await _auth.currentUser();
      if (user != null) {
        loggedInUser = user;
        saveUserInfoToFireStore(user);
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  /// Saves a new user to Firebase
  ///
  /// Additionally, retrieve the user's
  /// data and save it to currentUser
  void saveUserInfoToFireStore(FirebaseUser user) async {
    DocumentSnapshot documentSnapshot = await
      usersReference.document(user.uid).get();
    if (!documentSnapshot.exists) {
      final username = await Navigator.pushNamed(context,
        CreateAccountPage.id);
      usersReference.document(user.uid).setData({
        'id': user.uid,
        'displayName': user.displayName,
        'username': username,
        'url': user.photoUrl,
        'email': user.email,
        'bio': '',
        'timestamp': timestamp,
      });
      documentSnapshot = await usersReference.document(user.uid).get();
    }
    currentUser = CurrentUser.fromDocument(documentSnapshot);
  }


  @override
  void initState() {
    pageController = PageController();
    super.initState();
    getCurrentUser();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: <Widget>[
          Feed(),
          ProductivityPage(),
          GoalsPage(),
          FriendsPage(),
          ProfilePage(),
        ],
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: FFNavigationBar(
        theme: FFNavigationBarTheme(
          barBackgroundColor: Colors.white,
          selectedItemBorderColor: Color(0XFFCC7E85),
          selectedItemBackgroundColor: Color(0XFF7D83FF),
          selectedItemIconColor: Colors.white,
          unselectedItemIconColor: Color(0XFF948B8B),
          itemWidth: 60,
        ),
        selectedIndex: _selectedIndex,
        onSelectTab: (index) {
          setState(() {
            _selectedIndex = index;
            pageController.jumpToPage(_selectedIndex);
          });
        },
        items: [
          FFNavigationBarItem(
            iconData: Icons.home,
            label: '',
          ),
          FFNavigationBarItem(
            iconData: Icons.lightbulb_outline,
            label: '',
          ),
          FFNavigationBarItem(
            iconData: Icons.assignment,
            label: '',
          ),
          FFNavigationBarItem(
            iconData: Icons.group,
            label: '',
          ),
          FFNavigationBarItem(
            iconData: Icons.face,
            label: '',
          ),
        ],
      ),
    );
  }
}
