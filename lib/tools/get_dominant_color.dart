// Calculate dominant color from ImageProvider
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:palette_generator/palette_generator.dart';

Future<Color> getImagePalette(ImageProvider imageProvider) async {
  final PaletteGenerator paletteGenerator =
      await PaletteGenerator.fromImageProvider(imageProvider);
  PaletteColor? color = paletteGenerator.darkVibrantColor;
  print(color);
  return color != null
      ? paletteGenerator.darkVibrantColor!.color
      : paletteGenerator.darkMutedColor?.color ?? Color(0xFF222222);
}
