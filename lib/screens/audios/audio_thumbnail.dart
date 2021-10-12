import 'dart:io';

import 'package:audiov/abstracts/audio_abstract.dart';
import 'package:audiov/controllers/audio_controller.dart';
import 'package:audiov/tools/get_metadata.dart';
import 'package:audiov/tools/human_readable_values.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';

import '../../models/audio_data.dart';
import '../../constants/constants.dart';
import 'package:flutter/material.dart';

class AudioThumbnail extends StatelessWidget {
  final AudioData audioFile;
  final int index;
  const AudioThumbnail({Key? key, required this.audioFile, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AudioController>(
        id: audioFile.path,
        builder: (audioController) {
          bool isPlaying = AudioState.playing == audioController.audioState &&
              audioFile.path == audioController.playingAudio!.path;
          return SizedBox(
            height: 80.0,
            child: ListTile(
                leading: Container(
                  height: 80,
                  width: 70,
                  decoration: BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(radius)),
                      image: DecorationImage(
                          image: audioFile.thumbnail == null
                              ? Image.asset("$audioDir/thumbnail.jpg").image
                              : Image.memory(
                                  audioFile.thumbnail!,
                                  errorBuilder: (_, error, stacktrace) =>
                                      Image.asset("$audioDir/thumbnail.jpg"),
                                ).image,
                          fit: BoxFit.cover)),
                ),
                title: Text(
                  audioFile.trackName,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(getHumanReadableSize(audioFile.size)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Visibility(
                      visible: audioController.audioState ==
                              AudioState.playing &&
                          audioController.playingAudio?.path == audioFile.path,
                      child: Lottie.asset(
                          "$animationDir/music_playing_dark.json",
                          height: 30,
                          width: 30,
                          repeat: true),
                    ),
                    Text(getHumanReadableDuration(
                        Duration(milliseconds: audioFile.duration))),
                    IconButton(
                        onPressed: () {
                          if (isPlaying)
                            audioController.stopAudio();
                          else
                            audioController.playAudio(audioFile, index);
                        },
                        icon: Icon(
                          isPlaying ? Iconsax.pause : Iconsax.play,
                          color: Theme.of(context).iconTheme.color,
                        ))
                  ],
                )),
          );
        });
  }
}
