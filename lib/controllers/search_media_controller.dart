import 'dart:async';
import 'dart:io';

import 'package:audiov/constants/constants.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:youtube_explode_dart/youtube_explode_dart.dart';

enum SearchState { active, waiting, error }

class SearchMediaController extends GetxController {
  RxList<Video> medias = <Video>[].obs;
  StreamSubscription<List<int>>? _subscription;
  IOSink? _fileStream;
  File? _file;
  bool downloading = false;
  Rx<SearchState> state = SearchState.active.obs;
  int progrssPercent = 0;
  String error = "";
  late YoutubeExplode _yt;
  SearchList? _videoList;
  SearchMediaController() {
    _yt = YoutubeExplode();
  }
  void searchMedia(String query) async {
    state.value = SearchState.waiting;
    try {
      medias.clear();
      if (query.startsWith("https://youtu.be/")) {
        Video video = await _yt.videos.get(query.substring(
          17,
        ));
        medias.add(video);
      } else {
        _videoList = await _yt.search.getVideos(query);

        _videoList?.forEach((p0) {
          medias.add(p0);
        });
      }
      error = "";
      state.value = SearchState.active;
    } catch (e) {
      error = e.toString().split(":")[1];
      state.value = SearchState.error;
    }
  }

  Future<bool> nextPage() async {
    bool isError = false;
    try {
      _videoList = await _videoList?.nextPage();
      _videoList?.forEach((p0) {
        medias.add(p0);
      });
    } catch (e) {
      debugPrint(e.toString());
      isError = true;
    }
    return isError;
  }

  Future<StreamManifest> getVideo(Video video) async =>
      await _yt.videos.streamsClient.getManifest(video.id);

  void downloadMedia(StreamInfo info, int index, String fileName) async {
    downloading = true;
    var stream = _yt.videos.streamsClient.get(info);
    _file = File(location + fileName);
    _fileStream = _file?.openWrite();

    int totalBytes = info.size.totalBytes;
    int recivedBytes = 0;

    _subscription = stream.listen((event) {});
    _subscription?.onData((bytes) {
      recivedBytes += bytes.length;
      progrssPercent = ((recivedBytes / totalBytes) * 100).toInt();
      update([index]);
      _fileStream?.add(bytes);
    });
    _subscription?.onDone(() async {
      downloading = false;

      await _fileStream?.flush();
      await _fileStream?.close();
    });
  }

  void stopDownloading() async {
    await _subscription?.cancel();
    downloading = false;
    await _fileStream?.flush();
    await _fileStream?.close();
    await _file?.delete();
    progrssPercent = 0;
  }
}
