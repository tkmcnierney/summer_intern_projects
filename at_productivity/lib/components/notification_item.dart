import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Represents a notification item on the Notification route
class NotificationItem extends StatelessWidget {
  // the unique ID of the notification's owner
  final String ownerID;
  // When this notification was created
  final Timestamp timestamp;
  // The type of notification
  final String type;
  // The current user's ID
  final String userID;
  // The URL of the notification owner's profile image
  final String url;
  // The notification owner's username
  final String username;
  // The content of the notification if it exists
  final String commentData;
  // The unique ID of the post
  final String postID;

  NotificationItem({
    this.ownerID,
    this.timestamp,
    this.type,
    this.userID,
    this.url,
    this.username,
    this.commentData,
    this.postID,
  }
  );

  factory NotificationItem.fromDocument(DocumentSnapshot doc) {
    return NotificationItem(
      ownerID: doc['ownerID'],
      timestamp: doc['timestamp'],
      type: doc['type'],
      userID: doc['userID'],
      url: doc['url'],
      username: doc['username'],
      commentData: doc['commentData'],
      postID: doc['postID'],
    );
  }
  /// Determines the notification type
  TextSpan notificationText() {
    if (this.type == 'like') {
      return TextSpan(
        text: ' liked your post!',
        style: TextStyle(
          color: Colors.grey,
        ),
      );
    } else if (this.type == 'comment') {
      return TextSpan(
        text: ' commented on your post!',
        style: TextStyle(
          color: Colors.grey,
        ),
      );
    } else if (this.type == 'follow') {
      return TextSpan(
        text: ' has connected with you!',
        style: TextStyle(
          color: Colors.grey,
        ),
      );
    } else {
      return TextSpan(
        text: ' cannot resolve notification',
        style: TextStyle(
          color: Colors.grey,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: this.url == null ? Icon(Icons.person, size: 28)
          : CachedNetworkImage(imageUrl: this.url, height: 28, width: 28,),
      title: RichText(
        text: TextSpan(
          text: this.username + ' ',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          children: <TextSpan>[
            notificationText(),
          ]
        ),
      ),
    );
  }
}
