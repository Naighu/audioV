import 'package:audiov/abstracts/audio_abstract.dart';
import 'package:audiov/constants/constants.dart';
import 'package:audiov/controllers/audio_controller.dart';
import 'package:audiov/tools/human_readable_values.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AudioPlayerControls extends StatelessWidget {
  final Duration currentDuartion;
  AudioPlayerControls({Key? key, required this.currentDuartion})
      : super(key: key);
  final AudioController _audioController = Get.find<AudioController>();
  final playerWidth = (Get.width - (defaultPadding * 2));

  @override
  Widget build(BuildContext context) {
    double pos = 0.0;
    return Column(
      children: [
        StreamBuilder<Duration>(
            stream: _audioController.onDurationChanged(),
            builder: (context, snapshot) {
              Duration duration = snapshot.data ?? currentDuartion;

              pos = (duration.inMilliseconds /
                      _audioController.playingAudio!.duration) *
                  (playerWidth - 10);
              return GestureDetector(
                  onHorizontalDragUpdate: _onHorizontalDragUpdate,
                  child: Column(
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(
                            maxHeight: 12.0, maxWidth: playerWidth),
                        child: Stack(
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Container(
                                height: 3,
                                color: Colors.white30,
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                height: 3,
                                width: pos,
                                color: Colors.white,
                              ),
                            ),
                            Positioned(
                              left: pos,
                              child: Container(
                                height: 12,
                                width: 12,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            getHumanReadableDuration(duration),
                            style: TextStyle(
                              color: Colors.white60,
                            ),
                          ),
                          Text(
                            getHumanReadableDuration(Duration(
                                milliseconds:
                                    _audioController.playingAudio!.duration)),
                            style: TextStyle(
                              color: Colors.white60,
                            ),
                          )
                        ],
                      )
                    ],
                  ));
            }),

        //controllers

        GetBuilder<AudioController>(
            id: "music-player",
            builder: (AudioController audioController) {
              bool isLoading = AudioState.loading == audioController.audioState;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      onPressed: () {
                        audioController.playPrev();
                      },
                      icon: Icon(Iconsax.previous,
                          size: 32, color: Theme.of(context).iconTheme.color)),
                  const SizedBox(
                    width: defaultPadding,
                  ),
                  InkWell(
                    onTap: () {
                      if (audioController.audioState == AudioState.playing)
                        audioController.pauseAudio();
                      else
                        audioController.resumeAudio();
                    },
                    child: Container(
                        padding: const EdgeInsets.all(5),
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                            color: audioController.audioBg,
                            shape: BoxShape.circle),
                        alignment: Alignment.center,
                        child: isLoading
                            ? CircularProgressIndicator()
                            : Icon(
                                audioController.audioState == AudioState.playing
                                    ? Iconsax.pause
                                    : Iconsax.play,
                                size: 32,
                                color: Theme.of(context).iconTheme.color)),
                  ),
                  const SizedBox(
                    width: defaultPadding,
                  ),
                  IconButton(
                      onPressed: () {
                        audioController.playNext();
                      },
                      icon: Icon(Iconsax.next,
                          size: 32, color: Theme.of(context).iconTheme.color)),
                ],
              );
            })
      ],
    );
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    double dx = details.globalPosition.dx;

    int milli =
        ((dx / (playerWidth - 10)) * _audioController.playingAudio!.duration)
            .toInt();

    _audioController.seekAudio(Duration(milliseconds: milli - 10));
  }
}
