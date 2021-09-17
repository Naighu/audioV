import 'dart:io';

import 'package:audiov/models/audio_data.dart';

abstract class AudioAbstract {
  Future<bool> playAudio(AudioData data);
  Future<bool> stopAudio();
  Future<bool> pauseAudio();
  Future<bool> resumeAudio();
  Future<bool> seekAudio(Duration duration);
}

enum AudioState { stop, playing, pause, finished }
enum PlayerType { mini, max, none }
