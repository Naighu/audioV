import 'package:audiov/audio_player/audio_player_mini.dart';
import 'package:audiov/constants/constants.dart';
import 'package:audiov/screens/search_media/search_media_layout.dart';
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

  late ScrollController _scrollController;
  final audioFiles = MediaFiles(10, [".mp3"]);
  // StreamController<FileSystemEntity>? _controller;

  @override
  void initState() {
    super.initState();
    debugPrint("fetching");
    _scrollController = ScrollController();
    Get.put(AudioController());

    _listenScroll();
    androidPermission(Permission.storage).then((value) {
      if (value)
        setState(() {
          _initilized = true;
          audioFiles.fetchAudio();
        });
    });
  }

  void _listenScroll() {
    _scrollController.addListener(() {
      ScrollPosition position = _scrollController.position;

      if (position.pixels == position.maxScrollExtent)
        audioFiles.subscription.resume();
      ;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(() {});
    _scrollController.dispose();
    super.dispose();
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
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SearchMediaLayout()));
              },
              icon: Icon(
                Iconsax.search_normal,
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
                StreamBuilder<List<FileSystemEntity>>(
                    stream: audioFiles.controller.stream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return _loading();

                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (_, index) {
                          return AudioThumbnail(
                              audioFile: snapshot.data![index]);
                        },
                      );
                    }),
                AudioPlayerMini()
              ],
            )
          : _loading(),
      bottomNavigationBar: AppNavbar(page: "audios"),
    );
  }

  Widget _loading() => Center(
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
      );
}
