import 'package:animations/animations.dart';
import 'package:audiov/abstracts/audio_abstract.dart';
import 'package:audiov/audio_player/audio_player_max.dart';
import 'package:marquee/marquee.dart';
import 'package:audiov/constants/constants.dart';
import 'package:audiov/controllers/audio_controller.dart';
import 'package:audiov/models/audio_data.dart';
import 'package:audiov/tools/human_readable_values.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';

class AudioPlayerMini extends StatelessWidget {
  final double factor;
  const AudioPlayerMini({Key? key, required this.factor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Duration _currentDuration = Duration.zero;
    ;
    return GetBuilder<AudioController>(
        id: "music-player",
        builder: (AudioController audioController) {
          if (audioController.playingAudio != null) {
            AudioData audioData = audioController.playingAudio!;
            bool isPlaying = AudioState.playing == audioController.audioState &&
                audioData.path == audioController.playingAudio!.path;

            return Padding(
              padding: EdgeInsets.only(top: Get.height * factor),
              child: OpenContainer(
                transitionType: ContainerTransitionType.fadeThrough,
                openBuilder: (context, _) => AudioPlayerMax(
                  currentDuartion: _currentDuration,
                ),
                closedBuilder: (context, callback) => Container(
                  color: Color(0xFF161616),
                  child: Stack(
                    children: [
                      ListTile(
                        minLeadingWidth: 0,
                        minVerticalPadding: 0,
                        onTap: () {
                          callback();
                        },
                        title: Row(
                          children: [
                            Hero(
                              tag: "thumbnail",
                              child: Container(
                                width: 55,
                                height: 55,
                                decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                    image: DecorationImage(
                                        image: audioData.thumbnail != null
                                            ? Image.memory(audioData.thumbnail!)
                                                .image
                                            : Image.asset(
                                                "$audioDir/thumbnail.jpg",
                                              ).image,
                                        fit: BoxFit.cover)),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Marquee(
                                text: audioData.trackName,
                              ),
                            ),
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
                                onPressed: () {
                                  audioController.stopAudio();
                                },
                                icon: Icon(
                                  Iconsax.close_circle,
                                  color: Theme.of(context).iconTheme.color,
                                ))
                          ],
                        ),
                        subtitle: Row(
                          children: [
                            StreamBuilder<Duration>(
                                stream: audioController.onDurationChanged(),
                                builder: (context, snapshot) {
                                  _currentDuration =
                                      snapshot.data ?? Duration.zero;
                                  return Text(getHumanReadableDuration(
                                      snapshot.data ?? Duration.zero));
                                }),
                            const SizedBox(width: 10),
                            Lottie.asset(
                                "$animationDir/music_playing_dark.json",
                                height: 30,
                                width: 30,
                                animate: audioController.audioState ==
                                    AudioState.playing,
                                repeat: true),
                          ],
                        ),
                      ),
                      Positioned(bottom: 0, child: PlayerMini()),
                    ],
                  ),
                ),
              ),
            );
          }
          return Offstage();
        });
  }
}

class PlayerMini extends StatelessWidget {
  const PlayerMini({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double pos = 0.0;
    final audioController = Get.find<AudioController>();
    final playerWidth = Get.width;
    return StreamBuilder<Duration>(
        stream: audioController.onDurationChanged(),
        builder: (context, snapshot) {
          Duration duration = snapshot.data ?? Duration.zero;

          pos = (duration.inMilliseconds /
                  audioController.playingAudio!.duration) *
              (playerWidth);
          return Container(
            height: 3,
            width: pos,
            color: Colors.white,
          );
        });
  }
}
