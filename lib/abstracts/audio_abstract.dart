import 'dart:io';

import 'package:audiov/models/audio_data.dart';

abstract class AudioAbstract {
  Future<bool> playAudio(AudioData data, int index);
  Future<bool> stopAudio();
  Future<bool> pauseAudio();
  Future<bool> resumeAudio();
  Future<bool> seekAudio(Duration duration);
}

enum AudioState { stop, playing, pause, finished, loading }
enum PlayerType { mini, max, none }
