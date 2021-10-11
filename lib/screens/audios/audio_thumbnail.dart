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
  final FileSystemEntity audioFile;
  const AudioThumbnail({Key? key, required this.audioFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AudioData>(
      future: getMetaData(File(audioFile.path)),
      builder: (_, snapshot) {
        return GetBuilder<AudioController>(
            id: audioFile.path,
            builder: (audioController) {
              AudioData audioData = snapshot.data ??
                  AudioData(
                      trackName: "",
                      path: "",
                      duration: 0,
                      size: 0,
                      bitrate: 0);
              bool isPlaying =
                  AudioState.playing == audioController.audioState &&
                      audioData.path == audioController.playingAudio!.path;
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
                              image: audioData.thumbnail == null
                                  ? Image.asset("$audioDir/thumbnail.jpg").image
                                  : Image.memory(
                                      snapshot.data!.thumbnail!,
                                      errorBuilder: (_, error, stacktrace) =>
                                          Image.asset(
                                              "$audioDir/thumbnail.jpg"),
                                    ).image,
                              fit: BoxFit.cover)),
                    ),
                    title: Text(
                      audioData.trackName,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(getHumanReadableSize(audioData.size)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Visibility(
                          visible: audioController.audioState ==
                                  AudioState.playing &&
                              audioController.playingAudio?.path ==
                                  audioFile.path,
                          child: Lottie.asset(
                              "$animationDir/music_playing_dark.json",
                              height: 30,
                              width: 30,
                              repeat: true),
                        ),
                        Text(getHumanReadableDuration(
                            Duration(milliseconds: audioData.duration))),
                        IconButton(
                            onPressed: () {
                              if (isPlaying)
                                audioController.stopAudio();
                              else
                                audioController.playAudio(snapshot.data!);
                            },
                            icon: Icon(
                              isPlaying ? Iconsax.pause : Iconsax.play,
                              color: Theme.of(context).iconTheme.color,
                            ))
                      ],
                    )),
              );
            });
      },
    );
  }
}
