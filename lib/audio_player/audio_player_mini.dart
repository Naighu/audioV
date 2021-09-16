import 'package:animations/animations.dart';
import 'package:audiov/audio_player/audio_player_max.dart';
import 'package:audiov/constants/constants.dart';
import 'package:audiov/controllers/audio_controller.dart';
import 'package:audiov/models/audio_data.dart';
import 'package:audiov/tools/human_readable_values.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AudioPlayerMini extends StatelessWidget {
  const AudioPlayerMini({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AudioController>(
        id: "music-player",
        builder: (AudioController audioController) {
          if (audioController.playingAudio != null) {
            AudioData audioData = audioController.playingAudio!;
            bool isPlaying = AudioState.playing == audioController.audioState &&
                audioData.path == audioController.playingAudio!.path;

            return Padding(
              padding: EdgeInsets.only(top: Get.height * 0.677),
              child: OpenContainer(
                transitionType: ContainerTransitionType.fadeThrough,
                openBuilder: (context, _) => AudioPlayerMax(),
                closedBuilder: (context, callback) => Container(
                  color: Colors.red,
                  child: ListTile(
                      minLeadingWidth: 0,
                      minVerticalPadding: 25,
                      onTap: () {
                        callback();
                      },
                      leading: Hero(
                        tag: "thumbnail",
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(radius)),
                          child: audioData.thumbnail != null
                              ? Image.memory(audioData.thumbnail!)
                              : Image.asset(
                                  "$audioDir/thumbnail.jpg",
                                ),
                        ),
                      ),
                      title: Text(
                        audioData.trackName,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: StreamBuilder<Duration>(
                          stream: audioController.onDurationChanged(),
                          builder: (context, snapshot) => Text(
                              getHumanReadableDuration(
                                  snapshot.data ?? Duration.zero))),
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
                      )),
                ),
              ),
            );
          }
          return Offstage();
        });
  }
}
