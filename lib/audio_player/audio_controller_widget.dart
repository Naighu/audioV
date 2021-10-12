import 'package:audiov/abstracts/audio_abstract.dart';
import 'package:audiov/constants/constants.dart';
import 'package:audiov/controllers/audio_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AudioControllerWidget extends StatelessWidget {
  const AudioControllerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AudioController>(
        id: "music-player",
        builder: (AudioController _audioController) {
          bool isLoading = AudioState.loading == _audioController.audioState;
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(onPressed: () {
                    _playinGroup(context, _audioController);
                  }, icon: GetX<AudioController>(builder: (_controller) {
                    return Icon(Iconsax.arrow_swap_horizontal,
                        size: 25,
                        color: _controller.playNextAudio.value
                            ? Theme.of(context).iconTheme.color
                            : Colors.white60);
                  })),
                  IconButton(
                      onPressed: () {
                        if (_audioController.isFav.value) {
                          _audioController
                              .removeFromFav(_audioController.playingAudio!);
                        } else
                          _audioController
                              .addToFav(_audioController.playingAudio!);

                        _audioController.isFav.value =
                            !_audioController.isFav.value;
                      },
                      icon: GetX<AudioController>(
                          builder: (_controller) => Icon(
                              _controller.isFav.value
                                  ? Icons.favorite
                                  : Iconsax.heart,
                              size: 25,
                              color: _controller.isFav.value
                                  ? Colors.red
                                  : Colors.white60))),
                  IconButton(onPressed: () {
                    _audioController.repeatMode.value =
                        !_audioController.repeatMode.value;
                    if (_audioController.repeatMode.value &&
                        _audioController.playNextAudio.value)
                      _audioController.playNextAudio.value = false;
                  }, icon: GetX<AudioController>(builder: (_controller) {
                    return Icon(Iconsax.repeate_music,
                        size: 25,
                        color: _controller.repeatMode.value
                            ? Theme.of(context).iconTheme.color
                            : Colors.white60);
                  })),
                ],
              ),
              const SizedBox(height: defaultPadding),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                      onPressed: () {
                        _audioController.playPrev();
                      },
                      icon: Icon(Iconsax.previous,
                          size: 32, color: Theme.of(context).iconTheme.color)),
                  const SizedBox(
                    width: defaultPadding,
                  ),
                  InkWell(
                    onTap: () {
                      if (_audioController.audioState == AudioState.playing)
                        _audioController.pauseAudio();
                      else
                        _audioController.resumeAudio();
                    },
                    child: Container(
                        padding: const EdgeInsets.all(5),
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                            color: _audioController.audioBg,
                            shape: BoxShape.circle),
                        alignment: Alignment.center,
                        child: isLoading
                            ? CircularProgressIndicator()
                            : Icon(
                                _audioController.audioState ==
                                        AudioState.playing
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
                        _audioController.playNext();
                      },
                      icon: Icon(Iconsax.next,
                          size: 32, color: Theme.of(context).iconTheme.color)),
                ],
              ),
            ],
          );
        });
  }

  void _playinGroup(BuildContext context, AudioController _audioController) {
    _audioController.playNextAudio.value =
        !_audioController.playNextAudio.value;
    if (_audioController.playNextAudio.value &&
        _audioController.repeatMode.value)
      _audioController.repeatMode.value = false;
    if (_audioController.playNextAudio.value)
      showModalBottomSheet(
          context: context,
          constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
              maxHeight: 120,
              maxWidth: MediaQuery.of(context).size.width),
          builder: (context) => Padding(
                padding: const EdgeInsets.only(
                    left: defaultPadding, right: defaultPadding * 2),
                child: GetX<AudioController>(builder: (controller) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          controller.playFromFav.value = true;
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Play from Favourites",
                                style: TextStyle(fontSize: 18),
                              ),
                              if (controller.playFromFav.value)
                                Icon(Iconsax.tick_circle5)
                            ]),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          controller.playFromFav.value = false;
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Play from All Songs",
                                style: TextStyle(fontSize: 18),
                              ),
                              if (!controller.playFromFav.value)
                                Icon(Iconsax.tick_circle5)
                            ]),
                      )
                    ],
                  );
                }),
              ));
  }
}
