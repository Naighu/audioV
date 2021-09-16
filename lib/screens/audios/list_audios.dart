import 'dart:async';

import 'package:audiov/audio_player/audio_player_mini.dart';

import '../../audio_player/player.dart';

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
  bool? _initilized;
  late List<FileSystemEntity> _audios;
  late AudioController _audioController;

  @override
  void initState() {
    super.initState();
    _audioController = Get.put(AudioController());
    _fetchAudio();
  }

  void _fetchAudio() {
    _audioController.getAudios().then((value) {
      setState(() {
        _audios = value;
        _initilized = true;
      });
    }).catchError(_onError);
  }

  FutureOr<Null> _onError(Object error) async {
    setState(() {
      _initilized = false;
    });
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
      body: _initilized == null
          ? Center(
              child: Text("Please wait ..."),
            )
          : _initilized!
              ? Stack(
                  children: [
                    ListView.builder(
                      itemCount: _audios.length,
                      itemBuilder: (_, index) {
                        return AudioThumbnail(audioFile: _audios[index]);
                      },
                    ),
                    AudioPlayerMini()
                  ],
                )
              : Center(
                  child: Text("Need permission to access"),
                ),
      bottomNavigationBar: AppNavbar(page: "audios"),
    );
  }
}
