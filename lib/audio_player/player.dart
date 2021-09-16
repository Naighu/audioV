import 'package:audiov/constants/constants.dart';
import 'package:audiov/controllers/audio_controller.dart';
import 'package:audiov/tools/human_readable_values.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AudioPlayerControls extends StatelessWidget {
  const AudioPlayerControls({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AudioController _audioController = Get.find<AudioController>();
    final playerWidth =
        (MediaQuery.of(context).size.width - (defaultPadding * 2));
    return Column(
      children: [
        StreamBuilder<Duration>(
            stream: _audioController.onDurationChanged(),
            builder: (context, snapshot) {
              Duration duration = snapshot.data ?? Duration.zero;
              double pos = (duration.inMilliseconds /
                      _audioController.playingAudio!.duration) *
                  (playerWidth - 9);
              return Column(
                children: [
                  ConstrainedBox(
                    constraints:
                        BoxConstraints(maxHeight: 12.0, maxWidth: playerWidth),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Container(
                            height: 3,
                            color: Colors.grey,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            height: 3,
                            width: pos,
                            color: Colors.black,
                          ),
                        ),
                        Positioned(
                          left: pos,
                          child: Container(
                            height: 12,
                            width: 12,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle, color: Colors.black),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(getHumanReadableDuration(duration)),
                      Text(getHumanReadableDuration(Duration(
                          milliseconds:
                              _audioController.playingAudio!.duration)))
                    ],
                  )
                ],
              );
            }),

        //controllers

        GetBuilder<AudioController>(
            id: "music-player",
            builder: (AudioController audioController) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {},
                      icon: Icon(Iconsax.previous,
                          size: 40, color: Theme.of(context).iconTheme.color)),
                  const SizedBox(
                    width: defaultPadding,
                  ),
                  IconButton(
                      onPressed: () {
                        if (audioController.audioState == AudioState.playing)
                          audioController.pauseAudio();
                        else
                          audioController.resumeAudio();
                      },
                      icon: Icon(
                          audioController.audioState == AudioState.playing
                              ? Iconsax.pause
                              : Iconsax.play,
                          size: 40,
                          color: Theme.of(context).iconTheme.color)),
                  const SizedBox(
                    width: defaultPadding,
                  ),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(Iconsax.next,
                          size: 40, color: Theme.of(context).iconTheme.color)),
                ],
              );
            })
      ],
    );
  }
}
