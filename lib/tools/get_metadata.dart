import 'dart:io';
import 'dart:typed_data';

import 'package:audiov/models/audio_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';

Future<AudioData> getMetaData(File audioFile) async {
  var metadata = await MetadataRetriever.fromFile(audioFile);
  Uint8List? thumbnail = metadata.albumArt;
  if (metadata.albumArt != null) {
    try {
      await decodeImageFromList(metadata.albumArt!);
      thumbnail = metadata.albumArt;
    } catch (e) {
      thumbnail = null;
    }
  }
  return AudioData(
      path: audioFile.path,
      bitrate: metadata.bitrate ?? 0,
      trackName:
          metadata.trackName ?? audioFile.path.split("/").last.split(".")[0],
      size: await audioFile.length(),
      thumbnail: thumbnail,
      duration: metadata.trackDuration ?? 0);
}
