import 'dart:ui';
import 'package:flutter/material.dart';

extension BlurExtension on Widget {
  Widget blurred({double sigma = 10.0}) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
      child: this,
    );
  }
}
