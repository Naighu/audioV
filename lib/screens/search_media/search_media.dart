import 'package:audiov/constants/constants.dart';
import 'package:audiov/controllers/search_media_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchMedia extends StatelessWidget {
  const SearchMedia({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0,
      child: TextField(
        decoration: InputDecoration(
            fillColor: Color(0xFFF0F0F0),
            filled: true,
            hintText: "Search music....",
            contentPadding: const EdgeInsets.only(left: 15, top: 5),
            border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(radius))),
            enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(radius))),
            focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(radius)))),
        onSubmitted: (String val) {
          Get.find<SearchMediaController>().searchMedia(val);
        },
      ),
    );
  }
}
