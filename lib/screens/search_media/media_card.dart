import 'package:audiov/constants/constants.dart';
import 'package:audiov/controllers/search_media_controller.dart';
import 'package:audiov/screens/download_media/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:intl/intl.dart';

class MediaCard extends StatelessWidget {
  final Video video;
  const MediaCard({Key? key, required this.video}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 120.0,
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            color: Color(0xFF161616)),
        child: InkWell(
          onTap: () {
            //Get.find<SearchMediaController>().getVideo(video);
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                useRootNavigator: true,
                builder: (context) => DownloadBottomSheetWigdet(video: video));
          },
          child: Row(
            children: [
              const SizedBox(width: 10),
              SizedBox(
                width: 100,
                height: 100,
                child: DecoratedBox(
                  decoration: BoxDecoration(),
                  child: Image.network(video.thumbnails.standardResUrl,
                      errorBuilder: (context, _, __) {
                    print("Error");
                    return Image.asset(
                      "assets/audio/thumbnail.jpg",
                    );
                  }, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: defaultPadding),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                      child: Text(video.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    Text(
                      "${video.author} • ${NumberFormat.compact().format(video.engagement.viewCount)} views",
                      style: TextStyle(color: Colors.white60),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
