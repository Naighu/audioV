// Calculate dominant color from ImageProvider
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:palette_generator/palette_generator.dart';

Future<Color> getImagePalette(ImageProvider imageProvider) async {
  final PaletteGenerator paletteGenerator =
      await PaletteGenerator.fromImageProvider(imageProvider);
  PaletteColor? color = Get.isDarkMode
      ? paletteGenerator.darkVibrantColor
      : paletteGenerator.lightVibrantColor;
  return color != null ? paletteGenerator.lightMutedColor!.color : Colors.white;
}
