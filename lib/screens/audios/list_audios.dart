import 'dart:isolate';

import 'package:audiov/audio_player/audio_player_mini.dart';
import 'package:audiov/constants/constants.dart';
import 'package:audiov/tools/get_files.dart';
import 'package:audiov/tools/permissions.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../controllers/audio_controller.dart';
import '../../widget_utils/navbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import "dart:io";
import 'audio_thumbnail.dart';

class ListAudios extends StatefulWidget {
  const ListAudios({Key? key}) : super(key: key);

  @override
  _ListAudiosState createState() => _ListAudiosState();
}

class _ListAudiosState extends State<ListAudios> {
  bool _initilized = false;

  late AudioController _audioController;

  @override
  void initState() {
    super.initState();
    debugPrint("fetching");
    _audioController = Get.put(AudioController());
    _fetchAudio();
  }

  void _fetchAudio() async {
    if (await androidPermission(Permission.storage)) {
      try {
        ReceivePort receivePort = ReceivePort();

        await Isolate.spawn(getAudios, receivePort.sendPort);
        receivePort.listen((message) {
          if (message is List)
            setState(() {
              _initilized = true;
              _audioController.audios = message as List<FileSystemEntity>;
            });
        });
      } catch (_) {}
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'My Audios',
          style: Theme.of(context).textTheme.headline1,
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Iconsax.search_normal1,
                color: Theme.of(context).iconTheme.color,
              )),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Iconsax.setting_2,
                color: Theme.of(context).iconTheme.color,
              )),
        ],
      ),
      body: _initilized
          ? Stack(
              children: [
                ListView.builder(
                  itemCount: _audioController.audios.length,
                  itemBuilder: (_, index) {
                    return AudioThumbnail(
                        audioFile: _audioController.audios[index]);
                  },
                ),
                AudioPlayerMini()
              ],
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset(
                      Get.isDarkMode
                          ? "$animationDir/audio_loading_dark.json"
                          : "$animationDir/audio_loading.json",
                      height: 130,
                      width: 130,
                      repeat: true),
                  Text("Please wait a moment ",
                      style: Theme.of(context).textTheme.subtitle1),
                ],
              ),
            ),
      bottomNavigationBar: AppNavbar(page: "audios"),
    );
  }
}
