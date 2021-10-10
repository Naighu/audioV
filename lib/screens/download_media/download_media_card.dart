import 'package:audiov/controllers/search_media_controller.dart';
import 'package:audiov/tools/human_readable_values.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class downloadMediaCard extends StatefulWidget {
  downloadMediaCard(
      {Key? key,
      required this.size,
      required this.index,
      required this.title,
      this.isAudio = true,
      required this.onDownload,
      required this.onStop})
      : super(key: key);
  final String title;
  final Function() onDownload, onStop;
  final int size, index;
  final bool isAudio;

  @override
  State<downloadMediaCard> createState() => _downloadMediaCardState();
}

class _downloadMediaCardState extends State<downloadMediaCard> {
  final SearchMediaController controller = Get.find<SearchMediaController>();
  bool _isDownloading = false;
  bool _isDownloaded = false;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (!_isDownloaded) {
          if (!controller.downloading) {
            widget.onDownload();
            setState(() {
              _isDownloading = true;
            });
          } else {
            widget.onStop();
            setState(() {
              _isDownloading = false;
            });
          }
        }
      },
      leading: Icon(widget.isAudio ? Iconsax.music : Iconsax.video,
          color: Theme.of(context).iconTheme.color),
      title: Text(widget.title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
              height: 20,
              width: 20,
              child: _isDownloading
                  ? GetBuilder<SearchMediaController>(
                      id: widget.index,
                      builder: (controller) {
                        if (!_isDownloaded &&
                            !controller.downloading &&
                            controller.progrssPercent == 100.0) {
                          _isDownloaded = true;
                        }

                        return _isDownloaded
                            ? Icon(
                                Iconsax.tick_circle,
                                color: Colors.green,
                              )
                            : CircularProgressIndicator(
                                value: controller.progrssPercent == 0
                                    ? null
                                    : (controller.progrssPercent / 100.0),
                              );
                      })
                  : Icon(Iconsax.arrow_down)),
          const SizedBox(width: 10),
          Text(getHumanReadableSize(widget.size)),
        ],
      ),
    );
  }
}
