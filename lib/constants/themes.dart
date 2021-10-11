import 'package:flutter/material.dart';

ThemeData themeData = ThemeData(
    brightness: Brightness.dark,
    backgroundColor: Colors.black,
    scaffoldBackgroundColor: Colors.black,
    iconTheme: IconThemeData(color: Colors.white, size: 25),
    primaryIconTheme: IconThemeData(color: Color(0xFF292D32), size: 25),
    primaryColor: Colors.white,
    disabledColor: Color(0xFF97A0A6),
    textTheme: TextTheme(
      headline1: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
      headline2: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
      caption: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 25, color: Colors.grey),
    ));
