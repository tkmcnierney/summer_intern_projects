import 'package:cloud_firestore/cloud_firestore.dart';

/// Represents the current user on the app
class CurrentUser {
  final String id;
  final String displayName;
  final String username;
  final String url;
  final String email;
  final String bio;

  CurrentUser({
    this.id,
    this.displayName,
    this.username,
    this.url,
    this.email,
    this.bio,
  });

  factory CurrentUser.fromDocument(DocumentSnapshot doc) {
    return CurrentUser(
      id: doc['id'],
      email: doc['email'],
      username: doc['username'],
      url: doc['photoUrl'],
      displayName: doc['displayName'],
      bio: doc['bio'],
    );
  }
}