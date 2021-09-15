import 'dart:io';

import 'package:audiov/controllers/audio_controller.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
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
        print("data is not null");
        return GetBuilder<AudioController>(
            id: snapshot.data!.path,
            builder: (audioController) {
              bool isPlaying =
                  AudioState.playing == audioController.audioState &&
                      audioData.path == audioController.playingAudioData!.path;
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

  String getHumanReadableSize(int length) {
    FileSize fileSize = FileSize(length);

    if (fileSize.totalBytes < 1024)
      return "${fileSize.totalBytes.truncate()} bytes";
    if (fileSize.totalKiloBytes < 1024)
      return "${fileSize.totalKiloBytes.truncate()} KB";
    if (fileSize.totalMegaBytes < 1024)
      return "${fileSize.totalMegaBytes.truncate()} MB";
    return "${fileSize.totalGigaBytes.truncate()} GB";
  }

  String getHumanReadableDuration(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours > 0)
      return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
    else
      return "$twoDigitMinutes:$twoDigitSeconds";
  }
}
