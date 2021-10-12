import 'package:audiov/constants/constants.dart';
import 'package:audiov/controllers/search_media_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchMediaTextField extends StatelessWidget {
  final TextEditingController? controller;
  const SearchMediaTextField({Key? key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0,
      child: TextField(
        controller: controller,
        style: TextStyle(fontSize: 12),
        decoration: InputDecoration(
            fillColor: Color(0xFF222222),
            filled: true,
            hintText: "Search music....",
            hintStyle: TextStyle(fontSize: 12),
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
