import 'package:audiov/audio_player/audio_player_mini.dart';
import 'package:audiov/constants/constants.dart';
import 'package:audiov/controllers/search_media_controller.dart';
import 'package:audiov/screens/download_media/bottom_sheet.dart';
import 'package:audiov/screens/search_media/search_media_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import 'media_card.dart';

class SearchMediaLayout extends StatefulWidget {
  const SearchMediaLayout({Key? key}) : super(key: key);

  @override
  State<SearchMediaLayout> createState() => _SearchMediaLayoutState();
}

class _SearchMediaLayoutState extends State<SearchMediaLayout> {
  late ScrollController _scrollController;
  late SearchMediaController _searchMediaController;
  late TextEditingController _textEditingController;
  RxBool showTextField = true.obs;
  @override
  void initState() {
    super.initState();
    _searchMediaController = Get.put(SearchMediaController());
    _textEditingController = TextEditingController();
    _scrollController = ScrollController()
      ..addListener(() async {
        if (_scrollController.position.atEdge &&
            _scrollController.position.pixels != 0.0) {
          await _searchMediaController.nextPage();
          setState(() {});
        }
        if (_scrollController.offset > 30.0 && showTextField.value) {
          showTextField.value = false;
        }
        if (_scrollController.offset < 30.0 && !showTextField.value)
          showTextField.value = true;
      });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _scrollController.dispose();
    Get.delete<SearchMediaController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //     elevation: 0.0,
        //     leading: IconButton(
        //         onPressed: () => Navigator.pop(context),
        //         icon: Icon(
        //           Icons.arrow_back,
        //           color: Theme.of(context).iconTheme.color,
        //         )),
        //     backgroundColor: Theme.of(context).backgroundColor),
        body: Stack(children: [
      NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context,
                  bool innerBoxIsScrolled) =>
              [
                SliverAppBar(
                    expandedHeight: 100.0,
                    backgroundColor: Theme.of(context).backgroundColor,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      titlePadding: const EdgeInsets.symmetric(
                          horizontal: defaultPadding, vertical: 10),
                      title: Obx(() {
                        return SizedBox(
                            height: 30,
                            child: !showTextField.value
                                ? InkWell(
                                    onTap: () {
                                      _scrollController.animateTo(0.0,
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.easeIn);
                                    },
                                    child: Text(
                                      _textEditingController.text,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                : SearchMediaTextField(
                                    controller: _textEditingController,
                                  ));
                      }),
                    )),
              ],
          body: Column(
            children: [
              Expanded(
                  child: GetX<SearchMediaController>(builder: (controller) {
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
          )),
      AudioPlayerMini(
        factor: 0.9,
      ),
    ]));
  }
}

class ListSearchMedias extends StatelessWidget {
  const ListSearchMedias({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _searchMediaController = Get.find<SearchMediaController>();
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
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
