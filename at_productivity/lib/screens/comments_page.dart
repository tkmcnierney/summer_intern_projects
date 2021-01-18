import 'package:atproductivity/screens/home_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Represents the route that appears when a user
///
/// clicks on the comment section.
class CommentPage extends StatefulWidget {
  /// ID of CommentPage in main.dart
  static final String id = 'comments';
  /// the unique ID of the post
  final postID;
  /// the unique ID of the post owner
  final ownerID;
  /// The URL to the owner's profile picture
  final url;

  CommentPage(
    this.postID,
    this.ownerID,
    this.url,
  );

  @override
  _CommentPageState createState() => _CommentPageState(
    this.postID,
    this.ownerID,
    this.url,
  );
}

class _CommentPageState extends State<CommentPage> {
  final postID;
  final ownerID;
  final url;
  TextEditingController textEditingController;

  _CommentPageState(
    this.postID,
    this.ownerID,
    this.url,
  );
  /// Pulls the stream of comments attributed to the "postID"
  createComments() {
    return StreamBuilder(
      // assign "stream" to the collection of "comments" assigned to
      // a particular "postID"
      stream: commentsReference.document(postID).collection('comments')
          .orderBy('timestamp', descending: false).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: SizedBox(
              height: 100,
              width: 100,
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return snapshot.error;
        } else {
          // List of Comment objects to be featured
          List<Comment> commentList = [];
          // Use factory method in Comment class to populate "commentList"
          snapshot.data.documents.forEach((comment) => commentList.add(
            Comment.fromDocument(comment)
          ));

          return ListView.builder(
            // Presents an empty container if "commentList" is empty
            itemCount: commentList == null ? 1 : commentList.length,
            itemBuilder: (context, index) {
              return commentList == null ? Container() : commentList[index];
          });
        }
      },
    );
  }
  /// Adds a comment to the relevant Firebase collection
  saveComment(String comment) {
    commentsReference.document(postID).collection('comments').add({
      'username': currentUser.username,
      'content': comment,
      'timestamp': Timestamp.now(),
      'url': currentUser.url,
      'userID': currentUser.id,
    });

    bool isPostOwner = ownerID == currentUser.id;
    // If the comment does not belong to the post owner,
    // add it to the activityFeedReference collection so
    // that it can be used as a notification
    if (!isPostOwner) {
      activityFeedReference.document(ownerID).collection('feedItems').add({
        'type': 'comment',
        'commentData': textEditingController.text,
        'postID': postID,
        'userID': currentUser.id,
        'username': currentUser.username,
        'userProfileImg': currentUser.url,
        'url': url,
        'timestamp': Timestamp.now(),
      });
    }
    setState(() {
      textEditingController.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
          child: createComments(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: TextFormField(
                      controller: textEditingController,
                      decoration: InputDecoration(
                        hintText: 'Share your thoughts',
                        suffixIcon: IconButton(
                          onPressed: () => textEditingController.text == '' ? null
                              : saveComment(textEditingController.text),
                          icon: Icon(Icons.arrow_upward),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Represents a single comment in the CommentPage
class Comment extends StatelessWidget {
  final String username;
  final String userID;
  final String url;
  final String content;
  final Timestamp timestamp;

  Comment({
    this.username,
    this.userID,
    this.url,
    this.content,
    this.timestamp,
  });

  factory Comment.fromDocument(DocumentSnapshot doc) {
    return Comment(
      username: doc['username'],
      userID: doc['userID'],
      url: doc['url'],
      content: doc['content'],
      timestamp: doc['timestamp'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: ListTile(
        leading: Column(
          children: <Widget>[
            this.url == null ? Icon(
              Icons.person,
              size: 28,
            ) : CachedNetworkImage(
            imageUrl: this.url,
            height: 28,
            width: 28,
            ),
            Text(
              this.username,
              style: TextStyle(
                fontSize: 9.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        title: Text(
          this.content,
          style: TextStyle(
            fontSize: 13,
          ),
        ),
        trailing: IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: () {
            // TODO: Add deleting/editing functionality
            print('delete or edit me!');
          },
        ),
      ),
    );
  }
}
