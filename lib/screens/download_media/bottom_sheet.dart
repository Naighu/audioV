import 'package:audiov/constants/constants.dart';
import 'package:audiov/controllers/search_media_controller.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import 'download_media_card.dart';

class DownloadBottomSheetWigdet extends StatefulWidget {
  final Video video;
  const DownloadBottomSheetWigdet({Key? key, required this.video})
      : super(key: key);

  @override
  State<DownloadBottomSheetWigdet> createState() =>
      _DownloadBottomSheetWigdetState();
}

class _DownloadBottomSheetWigdetState extends State<DownloadBottomSheetWigdet> {
  late StreamManifest manifest;
  bool _loading = true;
  late SearchMediaController controller;
  @override
  void initState() {
    super.initState();
    controller = Get.find<SearchMediaController>();
    controller.getVideo(widget.video).then((value) {
      manifest = value;
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: defaultPadding * 2),
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Image.network(
              widget.video.thumbnails.standardResUrl,
              errorBuilder: (context, _, __) {
                return Image.asset("assets/audio/thumbnail.jpg");
              },
            ),
            title: SizedBox(
                height: 40,
                child: Text(widget.video.title,
                    style: TextStyle(fontWeight: FontWeight.bold))),
          ),
          _loading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                  ],
                )
              : Expanded(
                  child: Column(children: [
                    ...List.generate(
                      manifest.audioOnly.length,
                      (index) => downloadMediaCard(
                        index: index,
                        title:
                            "Audio/${manifest.audioOnly.toList()[index].audioCodec}",
                        size:
                            manifest.audioOnly.toList()[index].size.totalBytes,
                        onDownload: () {
                          print("calling ");
                          Get.find<SearchMediaController>().downloadMedia(
                            manifest.audioOnly.toList()[index],
                            index,
                            widget.video.title + ".mp3",
                          );
                        },
                        onStop: () {
                          Get.find<SearchMediaController>().stopDownloading();
                        },
                      ),
                    ),
                    const Divider(
                      thickness: 3.0,
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: manifest.video.length,
                          itemBuilder: (context, index) => downloadMediaCard(
                                index: index,
                                title:
                                    "Video/${manifest.video.toList()[index].videoQualityLabel}",
                                size: manifest.video
                                    .toList()[index]
                                    .size
                                    .totalBytes,
                                isAudio: false,
                                onDownload: () {
                                  Get.find<SearchMediaController>()
                                      .downloadMedia(
                                    manifest.video.toList()[index],
                                    index,
                                    widget.video.title + ".mp4",
                                  );
                                },
                                onStop: () {
                                  Get.find<SearchMediaController>()
                                      .stopDownloading();
                                },
                              )),
                    )
                  ]),
                )
        ],
      ),
    );
  }
}
