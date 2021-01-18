import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A widget for the header of every route.
AppBar header(context, {bool isAppTitle=true, String strTitle, disappearedBackButton=true}) {
  return AppBar(
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    automaticallyImplyLeading: disappearedBackButton ? false : true,
    title: Text(
      isAppTitle ? '@Productivity' : strTitle,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
        color: Colors.white,
      ),
      overflow: TextOverflow.fade,
    ),
    centerTitle: true,
    backgroundColor: Colors.black,
  );
}
