import 'package:audiov/constants/constants.dart';
import 'package:audiov/controllers/audio_controller.dart';
import 'package:audiov/models/audio_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class MediaPlayerMini extends StatelessWidget {
  const MediaPlayerMini({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AudioController>(
        id: "music-player",
        builder: (AudioController audioController) {
          if (audioController.playingAudioData != null) {
            AudioData audioData = audioController.playingAudioData!;
            bool isPlaying = AudioState.playing == audioController.audioState &&
                audioData.path == audioController.playingAudioData!.path;
            print(isPlaying);
            return Container(
                color: Colors.red,
                margin: EdgeInsets.only(top: Get.height * 0.675),
                height: 70.0,
                child: ListTile(
                    minLeadingWidth: 0,
                    minVerticalPadding: 25,
                    leading: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(radius)),
                      child: audioData.thumbnail != null
                          ? Image.memory(audioData.thumbnail!)
                          : Image.asset(
                              "$audioDir/thumbnail.jpg",
                            ),
                    ),
                    title: Text(
                      audioData.trackName,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              if (isPlaying)
                                audioController.pauseAudio();
                              else
                                audioController.resumeAudio();
                            },
                            icon: Icon(
                              isPlaying ? Iconsax.pause : Iconsax.play,
                              color: Theme.of(context).iconTheme.color,
                            )),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Iconsax.next,
                              color: Theme.of(context).iconTheme.color,
                            ))
                      ],
                    )));
          }
          return Offstage();
        });
  }
}
