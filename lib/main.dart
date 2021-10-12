import 'dart:io';

import 'package:audiov/constants/constants.dart';
import 'package:audiov/constants/themes.dart';

import 'package:audiov/screens/audios/list_audios.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'audio_player/audio_player_mini.dart';

void main() async {
  Directory dir = Directory(location);
  if (!dir.existsSync()) {
    dir.createSync();
  }
  Hive.init(dir.path);
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
