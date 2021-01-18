import 'package:atproductivity/screens/comments_page.dart';
import 'package:atproductivity/screens/home_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'current_user.dart';

/// Represents a single post on the feed
// ignore: must_be_immutable
class UserPost extends StatefulWidget {
  // The unique ID of the post
  final String postID;
  // The unique ID of the post owner
  final String ownerID;
  // The time the post was created
  final Timestamp timestamp;
  // A map that is used to track the individuals
  // who've liked and un-liked a post through
  // true and false values
  final Map likes;
  // The post owner's username
  final String username;
  // The description that accompanies the post
  final String description;
  // The URL to the owner's profile picture
  final String url;
  // The current user's ID
  String currentOnlineID = loggedInUser?.uid;
  // Set whether or not the current user has liked
  // the post to false
  bool isLiked = false;

  UserPost({
    this.postID,
    this.ownerID,
    this.timestamp,
    this.likes,
    this.username,
    this.description,
    this.url,
  });

  factory UserPost.fromDocument(DocumentSnapshot snapshot) {
    return UserPost(
      postID: snapshot['postID'],
      ownerID: snapshot['ownerID'],
      timestamp: snapshot['timestamp'],
      likes: snapshot['likes'],
      username: snapshot['username'],
      description: snapshot['description'],
      url: snapshot['url'],
    );
  }
  /// Returns the numerical value of the number of
  ///
  /// true values in the "likes" map
  int getTotalNumberOfLikes() {
    if (this.likes == null) {
      return 0;
    }
    int counter = 0;
    this.likes.forEach((key, value) {
      if (value == true) {
        counter++;
      }
    });
    return counter;
  }

  /// Compares the timestamps of separate posts
  int compareTo(UserPost other) {
    return this.timestamp.compareTo(other.timestamp) * -1;
  }

  @override
  State<StatefulWidget> createState() => _PostState(
    this.postID,
    this.ownerID,
    this.timestamp,
    this.likes,
    this.username,
    this.description,
    this.url,
    getTotalNumberOfLikes(),
  );
}

class _PostState extends State<UserPost> {
  final String postID;
  final String ownerID;
  final Timestamp timestamp;
  final Map likes;
  final String username;
  final String description;
  final String url;
  // The number of likes associated with a given post
  int likeCount;
  String currentOnlineID = loggedInUser?.uid;
  bool isLiked;

  _PostState(
      this.postID,
      this.ownerID,
      this.timestamp,
      this.likes,
      this.username,
      this.description,
      this.url,
      this.likeCount,
      );

  /// Method for when a user removes a like from a post
  removeLike() {
    bool isNotPostOwner = currentOnlineID != ownerID;
    if (isNotPostOwner) {
      activityFeedReference.document(ownerID).collection('feedItems').document(postID).get().then((value) {
        if (value.exists) {
          value.reference.delete();
        }
      });
    }
  }

  /// Method for when a user likes a post
  addLike() {
    bool isNotPostOwner = currentOnlineID != ownerID;
    if (isNotPostOwner) {
      activityFeedReference.document(ownerID).collection('feedItems').document(postID).setData({
        'type': 'like',
        'username': currentUser.username,
        'userID': currentUser.id,
        'timestamp': Timestamp.now(),
        'url': url,
        'postID': postID,
        'userProfileImg': currentUser.url,
      });
    }
  }

  /// Updates the variables related to the likes of a post
  controlUserLikePost() {
    bool _liked = likes[currentOnlineID] == true;
    if (_liked) {
      // Update the Map value stored in Firebase to "false"
      postsReference.document(ownerID).collection('posts').document(postID).updateData({'likes.$currentOnlineID': false});
      removeLike();
      // Update the class variables so that it is reflected on the user's screen
      setState(() {
        likeCount--;
        isLiked = false;
        likes[currentOnlineID] = false;
      });}
    else if (!_liked) {
      postsReference.document(ownerID).collection('posts').document(postID).updateData({'likes.$currentOnlineID': true});
      addLike();
      setState(() {
        likeCount++;
        isLiked = true;
        likes[currentOnlineID] = true;
      });
    }
  }

  /// A method that directs the user to the CommentPage
  displayComments(BuildContext context, String post, String owner, String url) {
    Navigator.push(context, MaterialPageRoute(
      builder: ((context) => CommentPage(post, owner, url))
    ));
  }

  /// A method that represents the header portion of a UserPost
  postHeader() {
    return FutureBuilder(
        future: usersReference.document(ownerID).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return snapshot.error;
          } else {
            CurrentUser user = CurrentUser.fromDocument(snapshot.data);
            bool isPostOwner = currentOnlineID == this.ownerID;
            return ListTile(
                leading: user.url == null ? Icon(
                  Icons.person,
                  size: 40,
                )
                    : CachedNetworkImage(
                  imageUrl: user.url,
                  height: 40,
                  width: 40,
                ),
                title: GestureDetector(
                  onTap: () {
                  },
                  child: Text(
                    this.username,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16
                    ),
                  ),
                ),
                trailing: isPostOwner ? IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.more_horiz),
                  color: Colors.grey,) : null
            );
          }
        }
    );
  }

  /// A method that represents the content of the UserPost
  postContent () {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Text(
              this.description,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 25),),
          GestureDetector(
            onDoubleTap: () {
              controlUserLikePost();
            },
            child: CachedNetworkImage(
              imageUrl: this.url,
              fit: BoxFit.fitWidth,
            ),
          ),
        ],
      ),
    );
  }

  /// A method that represents the footer of a UserPost
  postFooter () {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 40, left: 20),),
            GestureDetector(
              onTap: () {
                controlUserLikePost();
              },
              child: Icon(
                isLiked? Icons.star : Icons.star_border,
                size: 28.0,
                color: isLiked ? Color(0XFFFFD046) : Colors.grey,
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 40, left: 20),),
            GestureDetector(
              onTap: () {
                displayComments(context, postID, ownerID, url);
              },
              child: Icon(Icons.chat_bubble_outline, size: 28, color: Colors.grey,),
            )
          ],
        ),
        Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Text(
                (likeCount).toString() + (likeCount == 1 ? ' like' : ' likes'),
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // Update isLiked based on the Map value assigned to currentOnlineID
    isLiked = likes[currentOnlineID] == true;
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          children: <Widget>[
            postHeader(),
            postContent(),
            postFooter(),
          ],
        ),
      ),
    );
  }
}


