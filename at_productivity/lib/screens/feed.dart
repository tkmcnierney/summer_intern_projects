import 'package:atproductivity/components/app_header.dart';
import 'package:atproductivity/components/user_post.dart';
import 'package:atproductivity/screens/home_page.dart';
import 'package:atproductivity/screens/upload_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Feed extends StatefulWidget {
  /// ID of Feed in main.dart
  static final String id = 'feed';

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> with TickerProviderStateMixin{
  // AnimationController for hiding the "post" icon
  AnimationController _hideAnimation;
  // The snapshot of posts to appear in the feed
  QuerySnapshot snapshot;
  // The list of posts to be displayed
  List postList;
  // A FirebaseAuth instance
  final _auth = FirebaseAuth.instance;
  // The currently signed-in user
  FirebaseUser signedInUser;

  /// Retrieves the current user of the app
  getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        signedInUser = user;
        setUpFeed(user);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _hideAnimation = AnimationController(
      vsync: this,
      duration: kThemeAnimationDuration
    );
  }

  @override
  void dispose() {
    super.dispose();
    _hideAnimation.dispose();
  }

  /// Retrieves the post collection from Firebase
  setUpFeed(FirebaseUser user) async  {
    QuerySnapshot group = await groupReference.document(user.uid)
        .collection('group').getDocuments();
    group.documents.forEach((doc) {
      retrieveDocument(doc.documentID);
    });
    // Retrieves any posts made by the signedInUser
    // after collecting all other posts on Firebase
    retrieveDocument(signedInUser.uid);
  }

  /// Retrieves all posts other than signedInUser's
  retrieveDocument(String docID) async {
    snapshot = await postsReference.document(docID).
    collection('posts').orderBy('timestamp', descending: true).getDocuments();
    setState(() {
      if (postList == null) {
        postList = snapshot.documents.map((documentSnapshot)
        => UserPost.fromDocument(documentSnapshot)).toList();
      } else {
        postList.addAll(snapshot.documents.map((documentSnapshot) =>
            UserPost.fromDocument(documentSnapshot)).toList());
      }
      // Sort the postList if it has more than one post
      if (postList != null && postList.length > 1) {
        postList.sort((a, b) => a.compareTo(b));
      }
    });
  }

  /// Determines whether or not the display the "post" icon
  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification.depth == 0) {
      if (notification is UserScrollNotification) {
        final UserScrollNotification userScroll = notification;
        switch (userScroll.direction) {
          case ScrollDirection.forward:
            _hideAnimation.forward();
            break;
          case ScrollDirection.reverse:
            _hideAnimation.reverse();
            break;
          case ScrollDirection.idle:
            break;
        }
      }
    }
    return false;
  }

  /// Displays the posts in postList if not null
  Container mediaFeed() {
    return Container(
      child: ListView.builder(
        itemCount: postList == null ? 0 : postList.length,
        itemBuilder: (BuildContext context, int index) {
          return postList == null ? Container() : postList[index];
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: _handleScrollNotification,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.jpeg'),
            fit: BoxFit.cover,
          )
        ),
        child: Scaffold(
          appBar: header(context),
          backgroundColor: Colors.transparent,
          body: Center(
            child: Column(
              children: <Widget>[
                Expanded(child: postList == null ? Center(
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: CircularProgressIndicator(),
                  ),
                )
                : mediaFeed()),
              ],
            ),
          ),
          floatingActionButton: ScaleTransition(
            scale: _hideAnimation,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pushNamed(context, UploadPage.id);
              },
              backgroundColor: Color(0XFF7D83FF),
              child: Icon(Icons.add),
            ),
          ),
        ),
      ),
    );
  }
}
