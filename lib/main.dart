import 'package:audiov/constants/themes.dart';
import 'package:audiov/screens/audios/list_audios.dart';
import 'package:audiov/screens/videos/a.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: "/",
        title: 'AudioV',
        theme: themeData,
        home: ListAudios());
  }
}
