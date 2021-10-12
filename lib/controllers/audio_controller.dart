import 'dart:io';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:audiov/abstracts/audio_abstract.dart';
import 'package:audiov/constants/constants.dart';
import 'package:audiov/tools/get_dominant_color.dart';
import 'package:audiov/tools/get_files.dart';
import 'package:audiov/tools/get_metadata.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../models/audio_data.dart';

class AudioController extends GetxController implements AudioAbstract {
  late AudioPlayer _audioPlayer;
  PlayerType _playerType = PlayerType.none;
  List<AudioData> audios = [], favAudios = [];
  RxBool repeatMode = false.obs,
      playNextAudio = false.obs,
      isFav = false.obs,
      playFromFav = false.obs;

  Color? audioBg;
  PlayerType get playerType => _playerType;
  int? _playingIndex;
  AudioData? _playingAudio;
  AudioData? get playingAudio => _playingAudio;
  AudioState _audioState = AudioState.stop;
  AudioState get audioState => _audioState;
  late Box _favouriteBox;

  AudioController(MediaFiles files) {
    files.controller.stream.listen((event) {
      audios = event;
    });
    _audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
    Hive.openBox(favBox).then((value) {
      _favouriteBox = value;
      _favouriteBox.keys.forEach((element) async {
        favAudios.add(await getMetaData(File(_favouriteBox.get(element))));
      });
    });
    _audioPlayer.onPlayerCompletion.listen((event) {
      if (repeatMode.value) {
        playAudio(_playingAudio!, _playingIndex!);
      } else if (playNextAudio.value) {
        if (playFromFav.value && favAudios.length == 0) {
          _audioState = AudioState.finished;
          update(["music-player", _playingAudio!.path], true);
        } else
          playNext();
      } else {
        _audioState = AudioState.finished;
        update(["music-player", _playingAudio!.path], true);
      }
    });
  }

  void dispose() async {
    super.dispose();
    await _favouriteBox.close();
  }

  Future<bool> playAudio(AudioData data, int index) async {
    _playingIndex = index;
    _audioState = AudioState.loading;
    AudioData? temp = _playingAudio;
    _playingAudio = data;

    update([
      "music-player",
      data.path,
    ], true);
    int result = await _audioPlayer.play(data.path, isLocal: true);
    if (data.thumbnail != null)
      audioBg = await getImagePalette(Image.memory(data.thumbnail!).image);
    else
      audioBg = Color(0xFF222222);
    if (_playerType == PlayerType.none) _playerType = PlayerType.max;
    if (result == 1) {
      _audioState = AudioState.playing;

      _playingAudio = data;

      isFav.value = isFavSong(_playingAudio!) != null;
      update(
          ["music-player", _playingAudio!.path, temp != null ? temp.path : ""],
          true);

      _playingAudio = data;

      return true;
    }
    return false;
  }

  Future<bool> stopAudio() async {
    int result = await _audioPlayer.stop();

    if (result == 1) {
      _audioState = AudioState.stop;

      update(["music-player", _playingAudio!.path], true);
      _playingAudio = null;
      audioBg = null;
      return true;
    }
    return false;
  }

  Future<bool> pauseAudio() async {
    int result = await _audioPlayer.pause();

    if (result == 1) {
      _audioState = AudioState.pause;

      update(["music-player", _playingAudio!.path], true);
      return true;
    }
    return false;
  }

  Future<bool> resumeAudio() async {
    int result = await _audioPlayer.resume();

    if (result == 1) {
      _audioState = AudioState.playing;

      update(["music-player", _playingAudio!.path], true);
      return true;
    }
    return false;
  }

  Future<bool> seekAudio(Duration duration) async {
    int result = await _audioPlayer.seek(duration);

    if (result == 1) {
      update(["music-player", _playingAudio!.path], true);
      return true;
    }
    return false;
  }

  Future<bool> playNext() async {
    try {
      int total;
      if (playNextAudio.value && playFromFav.value)
        total = favAudios.length;
      else
        total = audios.length;

      int number = _playingIndex! + 1;
      if (number >= total) number = 0;
      print(number);
      print(playFromFav.value);
      playAudio(
          playNextAudio.value && playFromFav.value
              ? favAudios[number]
              : audios[number],
          number);

      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> playPrev() async {
    try {
      int total = playFromFav.value ? favAudios.length : audios.length;

      int number = _playingIndex! - 1;
      if (number < 0) number = total - 1;
      playAudio(playFromFav.value ? favAudios[number] : audios[number], number);

      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  void changePlayerType(PlayerType type) {
    _playerType = type;
    update(["music-player"], true);
  }

  Stream<Duration> onDurationChanged() => _audioPlayer.onAudioPositionChanged;

  void addToFav(AudioData data) async {
    if (isFavSong(data) == null) {
      _favouriteBox.add(data.path);
      favAudios.add(data);
    }
  }

  void removeFromFav(AudioData data) async {
    _favouriteBox.delete(isFavSong(data));
    for (int i = 0; i < favAudios.length; i++) {
      if (favAudios[i].path == data.path) {
        favAudios.removeAt(i);
        break;
      }
    }
  }

  int? isFavSong(AudioData data) {
    final keys = _favouriteBox.keys.iterator;
    int? index = null;
    while (keys.moveNext()) {
      if (data.path == _favouriteBox.get(keys.current)) {
        index = keys.current;
        break;
      }
    }

    return index;
  }
}
