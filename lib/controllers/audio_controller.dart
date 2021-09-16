import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import '../models/audio_data.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class AudioAbstract {
  Future<AudioData> getMetaData(File audioFile);
  Future<List<FileSystemEntity>> getAudios();
  Future<bool> playAudio(AudioData data);
  Future<bool> stopAudio();
  Future<bool> pauseAudio();
  Future<bool> resumeAudio();
}

enum AudioState { stop, playing, pause, finished }
enum PlayerType { mini, max, none }

class AudioController extends GetxController implements AudioAbstract {
  late AudioPlayer _audioPlayer;
  PlayerType _playerType = PlayerType.none;
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

  Future<bool> _hasPermission() async {
    var status = await Permission.storage.status;
    while (status.isDenied) {
      status = await Permission.storage.request();
    }
    if (status.isPermanentlyDenied) {
      return false;
    }
    return true;
  }

  Future<List<FileSystemEntity>> getAudios() async {
    if (!(await _hasPermission())) return [];
    Directory dir = Directory('/storage/emulated/0/');

    List<FileSystemEntity> _files;
    List<FileSystemEntity> _songs = [];
    _files = dir.listSync(recursive: true, followLinks: false);
    for (FileSystemEntity entity in _files) {
      String path = entity.path;
      if (path.endsWith('.mp3')) _songs.add(entity);
    }

    return _songs;
  }

  @override
  Future<AudioData> getMetaData(File audioFile) async {
    var metadata = await MetadataRetriever.fromFile(audioFile);

    return AudioData(
        path: audioFile.path,
        bitrate: metadata.bitrate ?? 0,
        trackName:
            metadata.trackName ?? audioFile.path.split("/").last.split(".")[0],
        size: await audioFile.length(),
        thumbnail: metadata.albumArt,
        duration: metadata.trackDuration ?? 0);
  }

  Future<bool> playAudio(AudioData data) async {
    int result = await _audioPlayer.play(data.path, isLocal: true);
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

  void changePlayerType(PlayerType type) {
    _playerType = type;
    update(["music-player"], true);
  }

  Stream<Duration> onDurationChanged() => _audioPlayer.onAudioPositionChanged;
}
