import 'package:audiov/constants/themes.dart';
import 'package:audiov/screens/audios/list_audios.dart';
import 'package:flutter/material.dart';

void main() async {
//   locator.registerLazySingletonAsync<AudioManager>(
//       () => AudioService.init<AudioManager>(
//             builder: () => AudioManager(),
//             config: AudioServiceConfig(
//               androidNotificationChannelId: 'com.example.audiov.channel.audio',
//               androidNotificationChannelName: 'Music playback',
//             ),
//           ));
// locator<AudioManager>().play
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'AudioV', theme: themeData, home: ListAudios());
  }
}
