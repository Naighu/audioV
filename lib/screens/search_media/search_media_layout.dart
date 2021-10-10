import 'package:audiov/constants/constants.dart';
import 'package:audiov/controllers/search_media_controller.dart';
import 'package:audiov/screens/download_media/bottom_sheet.dart';
import 'package:audiov/screens/search_media/search_media.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'media_card.dart';

class SearchMediaLayout extends StatelessWidget {
  const SearchMediaLayout({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0.0,
            leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).iconTheme.color,
                )),
            backgroundColor: Theme.of(context).backgroundColor),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding * 0.5, vertical: 5),
              child: SearchMedia(),
            ),
            Expanded(
                child: GetX<SearchMediaController>(
                    init: SearchMediaController(),
                    builder: (controller) {
                      return controller.state == SearchState.waiting
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                              ],
                            )
                          : controller.state == SearchState.error
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Lottie.asset(
                                        "assets/animations/error_light.json"),
                                    Text(controller.error)
                                  ],
                                )
                              : ListSearchMedias();
                    }))
          ],
        ));
  }
}

class ListSearchMedias extends StatefulWidget {
  const ListSearchMedias({Key? key}) : super(key: key);

  @override
  _ListSearchMediasState createState() => _ListSearchMediasState();
}

class _ListSearchMediasState extends State<ListSearchMedias> {
  late ScrollController _scrollController;
  late SearchMediaController _searchMediaController;

  @override
  void initState() {
    super.initState();
    _searchMediaController = Get.find<SearchMediaController>();
    _scrollController = ScrollController()
      ..addListener(() async {
        if (_scrollController.position.atEdge &&
            _scrollController.position.pixels != 0.0) {
          await _searchMediaController.nextPage();
          setState(() {});
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        controller: _scrollController,
        itemCount: _searchMediaController.medias.length == 0
            ? 0
            : _searchMediaController.medias.length + 1,
        itemBuilder: (context, index) {
          return index == _searchMediaController.medias.length
              ? Center(
                  child: Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Text("Loading ..."),
                ))
              : MediaCard(
                  video: _searchMediaController.medias[index],
                );
        });
  }
}
