import 'dart:io';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:audiov/abstracts/audio_abstract.dart';
import 'package:audiov/tools/get_dominant_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/audio_data.dart';

class AudioController extends GetxController implements AudioAbstract {
  late AudioPlayer _audioPlayer;
  PlayerType _playerType = PlayerType.none;

  Color? audioBg;
  PlayerType get playerType => _playerType;
  AudioData? _playingAudio;
  AudioData? get playingAudio => _playingAudio;
  AudioState _audioState = AudioState.stop;
  AudioState get audioState => _audioState;

  AudioController() {
    _audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
    _audioPlayer.onPlayerCompletion.listen((event) {
      _audioState = AudioState.finished;
      update(["music-player", _playingAudio!.path], true);
    });
  }

  Future<bool> playAudio(AudioData data) async {
    int result = await _audioPlayer.play(data.path, isLocal: true);
    if (data.thumbnail != null)
      audioBg = await getImagePalette(Image.memory(data.thumbnail!).image);
    else
      audioBg = Color(0xFF222222);
    if (_playerType == PlayerType.none) _playerType = PlayerType.max;
    if (result == 1) {
      _audioState = AudioState.playing;
      if (_playingAudio == null)
        update([
          "music-player",
          data.path,
        ], true);
      else {
        AudioData temp = _playingAudio!;
        _playingAudio = data;
        update(["music-player", _playingAudio!.path, temp.path], true);
      }
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

  void changePlayerType(PlayerType type) {
    _playerType = type;
    update(["music-player"], true);
  }

  Stream<Duration> onDurationChanged() => _audioPlayer.onAudioPositionChanged;
}
