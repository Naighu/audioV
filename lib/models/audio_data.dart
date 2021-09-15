import 'dart:typed_data';

class AudioData {
  final String trackName;
  final String path;
  final int bitrate, duration, size;
  final Uint8List? thumbnail;

  AudioData(
      {required this.trackName,
      required this.path,
      this.thumbnail,
      required this.duration,
      required this.size,
      required this.bitrate});
}
