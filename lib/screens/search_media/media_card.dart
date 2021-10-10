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
    return SizedBox(
        height: 120.0,
        child: ListTile(
          onTap: () {
            //Get.find<SearchMediaController>().getVideo(video);
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                useRootNavigator: true,
                builder: (context) => DownloadBottomSheetWigdet(video: video));
          },
          leading: Image.network(
            video.thumbnails.standardResUrl,
            errorBuilder: (context, _, __) {
              return Image.asset("assets/audio/thumbnail.jpg");
            },
          ),
          title: SizedBox(
              height: 40,
              child: Text(video.title,
                  style: TextStyle(fontWeight: FontWeight.bold))),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Text(
                "${video.author} • ${NumberFormat.compact().format(video.engagement.viewCount)} views"),
          ),
        ));
  }
}
