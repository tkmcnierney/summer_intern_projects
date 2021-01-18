import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:image/image.dart' as ImD;

import 'home_page.dart';

/// Represents the upload screen for a new post
class UploadPage extends StatefulWidget {
  /// ID of UploadPage in main.dart
  static final String id = 'upload';
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  // Selects an image from the gallery or camera
  final picker = ImagePicker();
  // The image file to be saved
  File file;
  // Determines whether the post is being saved
  bool uploading = false;
  // A unique ID for the new post
  String postID = Uuid().v4();
  TextEditingController textEditingController;


  /// Compresses the selected image
  compressingPhoto() async {
    final tDirectory = await getTemporaryDirectory();
    final path = tDirectory.path;
    ImD.Image imageFile = ImD.decodeImage(this.file.readAsBytesSync());
    final compressedImageFile = File('$path/img_$postID.jpg')
      ..writeAsBytesSync(ImD.encodeJpg(imageFile, quality: 60));
    setState(() {
      this.file = compressedImageFile;
    });
  }

  /// Saves the photo to Firebase and returns an image URL
  Future<String> uploadPhoto(File photo) async {
    StorageUploadTask mStorageUploadTask = storageReference.child(
        'post_$postID.jpg').putFile(photo);
    StorageTaskSnapshot storageTaskSnapshot = await mStorageUploadTask
        .onComplete;
    String downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  /// Share a completed post and resets variables
  sharePost() async {
    setState(() {
      uploading = true;
    });
    await compressingPhoto();
    String downloadUrl = await uploadPhoto(this.file);
    savePostToFireStore(
        url: downloadUrl, description: textEditingController.text);
    textEditingController.clear();
    setState(() {
      this.file = null;
      uploading = false;
      postID = Uuid().v4();
    });
    Navigator.pop(context);
  }

  /// Adds post to Firebase
  savePostToFireStore({String url, String description}) {
    postsReference.document(loggedInUser.uid).collection('posts').document(postID).setData({
      'postID': postID,
      'ownerID': loggedInUser.uid,
      'timestamp': Timestamp.now(),
      'likes': {},
      'username': currentUser.username,
      'description': description,
      'url': url,
    });
  }

  /// Called when an image is taken from camera
  takeFromCamera() async {
    PickedFile imageFile = await picker.getImage(
      source: ImageSource.camera,
      maxHeight: 680,
      maxWidth: 970,
    );
    if (imageFile != null) {
      setState(() {
        this.file = File(imageFile.path);
      });
    }
  }

  /// Called when an image is chosen from a gallery
  takeFromGallery() async {
    PickedFile imageFile = await picker.getImage(
      source: ImageSource.gallery,
    );
    if (imageFile != null) {
      setState(() {
        this.file = File(imageFile.path);
      });
    }
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

  /// Represents the upload screen
  Widget createUploadPage() {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Material(
              child: TextField(
                controller: textEditingController,
                maxLines: 4,
                cursorColor: Color(0XFF7D83FF),
                decoration: InputDecoration.collapsed(hintText: 'What do you want to share today?'),
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: 230,
          child: Center(
            child: Container(
              decoration: this.file == null ? null : BoxDecoration(
                image: DecorationImage(
                  image: FileImage(this.file),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              MaterialButton(
                onPressed: () {
                  takeFromCamera();
                },
                child: Icon(
                  Icons.add_a_photo,
                  color: Colors.grey,
                  size: 100.0,
                ),
              ),
              MaterialButton(
                onPressed: () {
                  takeFromGallery();
                },
                child: Icon(
                  Icons.add_photo_alternate,
                  color: Colors.grey,
                  size: 100.0,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: uploading,
      child: Center(
        child: SafeArea(
          child: Scaffold(
            appBar: AppBar(
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
              title: Text(
                '@Productivity',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
                overflow: TextOverflow.fade,
              ),
              centerTitle: true,
              backgroundColor: Colors.black,
              actions: <Widget>[
                MaterialButton(
                  onPressed: uploading || textEditingController.text == null
                      || this.file == null ? null : () => sharePost(),
                  child: Text(
                    'Share',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
            body: createUploadPage(),
          ),
        ),
      ),
    );
  }
}
