import 'package:flutter/material.dart';

ThemeData themeData = ThemeData(
    backgroundColor: Colors.white,
    scaffoldBackgroundColor: Colors.white,
    iconTheme: IconThemeData(color: Color(0xFF292D32), size: 25),
    primaryIconTheme: IconThemeData(color: Color(0xFF292D32), size: 25),
    primaryColor: Colors.black,
    disabledColor: Color(0xFF97A0A6),
    textTheme: TextTheme(
      headline1: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 25, color: Colors.black),
      headline2: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
      caption: TextStyle(
          fontWeight: FontWeight.bold, fontSize: 25, color: Color(0xFF161616)),
    ));
