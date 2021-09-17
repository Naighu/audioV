import 'dart:io';

import 'package:audiov/controllers/audio_controller.dart';
import 'package:audiov/tools/human_readable_values.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../../models/audio_data.dart';
import '../../constants/constants.dart';
import '../../main.dart';
import 'package:flutter/material.dart';

class AudioThumbnail extends StatelessWidget {
  final FileSystemEntity audioFile;
  const AudioThumbnail({Key? key, required this.audioFile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AudioData>(
      future: Get.find<AudioController>().getMetaData(File(audioFile.path)),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Text("Getting meta data");
        AudioData audioData = snapshot.data!;
        ;
        return GetBuilder<AudioController>(
            id: snapshot.data!.path,
            builder: (audioController) {
              bool isPlaying =
                  AudioState.playing == audioController.audioState &&
                      audioData.path == audioController.playingAudio!.path;
              return SizedBox(
                height: 80.0,
                child: ListTile(
                    onTap: () {
                      if (isPlaying)
                        audioController.stopAudio();
                      else
                        audioController.playAudio(snapshot.data!);
                    },
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
                              "$animationDir/music_playing_light.json",
                              height: 30,
                              width: 30,
                              repeat: true),
                        ),
                        Text(getHumanReadableDuration(
                            Duration(milliseconds: audioData.duration))),
                        Icon(
                          isPlaying ? Iconsax.pause : Iconsax.play,
                          color: Theme.of(context).iconTheme.color,
                        )
                      ],
                    )),
              );
            });
      },
    );
  }
}
