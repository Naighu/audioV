import 'package:audiov/constants/constants.dart';
import 'package:audiov/controllers/audio_controller.dart';
import 'package:audiov/models/audio_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'player.dart';

class AudioPlayerMax extends StatelessWidget {
  final Duration currentDuartion;
  const AudioPlayerMax({
    Key? key,
    this.currentDuartion = Duration.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.find<AudioController>().audioBg,
      appBar: AppBar(
          backgroundColor: Get.find<AudioController>().audioBg,
          elevation: 0.0,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_drop_down,
                color: Theme.of(context).iconTheme.color,
              ))),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        child: GetBuilder<AudioController>(
            id: "music-player",
            builder: (AudioController playerController) {
              if (playerController.playingAudio == null) return Offstage();

              AudioData audio = playerController.playingAudio!;
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: defaultPadding),
                    child: AspectRatio(
                      aspectRatio: 16 / 16,
                      child: Hero(
                        tag: "thumbnail",
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: audio.thumbnail == null
                                    ? Image.asset("$audioDir/thumbnail.jpg")
                                        .image
                                    : Image.memory(audio.thumbnail!).image,
                                fit: BoxFit.cover),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(radius)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        maxWidth: Get.width - defaultPadding * 2,
                        maxHeight: 60),
                    child: Text(
                      audio.trackName,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ),
                  AudioPlayerControls(
                    currentDuartion: currentDuartion,
                  )
                ],
              );
            }),
      ),
    );
  }
}
