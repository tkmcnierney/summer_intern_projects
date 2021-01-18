
import 'package:atproductivity/components/current_user.dart';
import 'package:atproductivity/components/notification_item.dart';
import 'package:atproductivity/screens/home_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

/// Displays the friend search functionality and notifications
class FriendsPage extends StatefulWidget {
  /// ID of FriendsPage in main.dart
  static final String id = 'friends';
  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  // TextEditingController for the friends' search bar
  TextEditingController searchBarController;
  // Retrieves registered users in Firebase
  final usersReference = Firestore.instance.collection('users');
  // Determines whether or not currentUser follows a user
  bool following = false;

  Future<List<CurrentUser>> performSearch(String username) async {
    QuerySnapshot allUsers = await usersReference.where('username',
        isGreaterThanOrEqualTo: username,).limit(10).getDocuments();
    List userList = allUsers.documents.map(
           (doc) => CurrentUser.fromDocument(doc)).toList();
    CurrentUser userToRemove;
    // Remove currentUser from search result
    for (var user in userList) {
      if (user.username == currentUser.username) {
        userToRemove = user;
      }
    }
    if (userToRemove != null) {
      userList.remove(userToRemove);
    }
    return userList;
  }

  /// Creates the search bar
  AppBar createSearchBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black,
      title: TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
          controller: searchBarController,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
          decoration: InputDecoration(
            hintText: 'search for @ handle',
            hintStyle: TextStyle(
              color: Colors.grey,
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear, color: Colors.white),
              onPressed: () {
                searchBarController.clear();
              }
            ),
          ),
        ),
        suggestionsCallback: (String username) async {
          List<CurrentUser> users = await performSearch(username);
          return users;
        },
        itemBuilder: (BuildContext context, CurrentUser itemData) {
          return ListTile(
            leading: Icon(Icons.person),
            title: Text(itemData.username),
          );
        },
        noItemsFoundBuilder: (BuildContext context) {
          return Padding(
            padding: EdgeInsets.all(5.0),
            child: Text(
              'No @ handle found!',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          );
        },
        onSuggestionSelected: (CurrentUser suggestion) {
          return determineFollower(suggestion);
        },
      ),
    );
  }

  /// Represents the popup upon clicking a user in the search bar
  createProfilePopUp(BuildContext context, CurrentUser user) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.fromBottom,
      isCloseButton: false,
      animationDuration: Duration(milliseconds: 400),
    );
    return Alert(
      context: context,
      content: Center(
        child: user.url == null ? Icon(Icons.person, size: 50)
      : CachedNetworkImage(
          imageUrl: user.url,
        ),
      ),
      title: user.username,
      style: alertStyle,
      buttons: [
        DialogButton(
          onPressed: () {
            controlFollowRequests(user);
          },
          child: Text(
            following ? 'Remove' : 'Invite',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          color: Color(0XFF7D83FF),
        )
      ]
    ).show();
  }

  /// Determine whether the user in the search bar is friends with currentUser
  determineFollower(CurrentUser otherUser) {
    activityFeedReference.document(otherUser.id)
    .collection('feedItems').document(currentUser.id).get().then(
    (document) {
      setState(() {
        following = document.exists;
      });
    }).whenComplete(() => createProfilePopUp(context, otherUser));
  }

  /// Actions to take based on whether or not the currentUser follows the other user
  controlFollowRequests(CurrentUser user) {
    if (following) {
      groupReference.document(user.id).collection('group').document(currentUser.id)
      .get().then((document) {
        if (document.exists) {
          document.reference.delete();
        }
      });
      groupReference.document(currentUser.id).collection('group').document(user.id)
          .get().then((document) {
        if (document.exists) {
          document.reference.delete();
        }
      });
      activityFeedReference.document(user.id).collection('feedItems').document(currentUser.id)
          .get().then((document) {
        if (document.exists) {
          document.reference.delete();
        }
      });
    } else {
      groupReference.document(user.id).collection('group').document(currentUser.id).setData({

      });
      groupReference.document(currentUser.id).collection('group').document(user.id).setData({

      });
      activityFeedReference.document(user.id).collection('feedItems').document(currentUser.id)
          .setData({
        'type': 'follow',
        'ownerID': user.id,
        'username': currentUser.username,
        'timestamp': Timestamp.now(),
        'userProfileImg': currentUser.url,
        'userID': currentUser.id,
      });
    }
    Navigator.pop(context);
  }

  /// Creates a list of NotificationItems
  createNotifications() {
    return FutureBuilder(
      future: activityFeedReference.document(currentUser.id)
          .collection('feedItems').orderBy('timestamp', descending: true).getDocuments(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else if (snapshot.hasError) {
          return snapshot.error;
        } else {
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index) {
              List notifications;
              notifications = snapshot.data.documents.map((document)
                => NotificationItem.fromDocument(document)).toList();
              return notifications == null ? Container() : notifications[index];
            }
          );
        }
      },
    );
  }
  
  @override
  void initState() {
    searchBarController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchBarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createSearchBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Text('Manage friends/groups'),
          ),
          ListTile(
            title: Text('View requests'),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0, top: 15.0),
            child: Text(
              'This past week',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(),
          Expanded(
            child: createNotifications(),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0),
            child: Text(
              'This past month',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Divider(),
          Expanded(
            child: SizedBox(
            ),
          ),
        ],
      ),
    );
  }
}
