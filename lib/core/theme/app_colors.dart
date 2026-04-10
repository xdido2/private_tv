import 'package:flutter/material.dart';

abstract class AppColors {
  static const Color background = Color(0xFF131313);
  static const Color surfaceDim = Color(0xFF131313);
  static const Color surfaceContainerLow = Color(0xFF1C1B1B);
  static const Color surfaceContainer = Color(0xFF201F1F);
  static const Color surfaceContainerHigh = Color(0xFF2A2A2A);
  static const Color surfaceContainerHighest = Color(0xFF353534);
  static const Color surfaceContainerLowest = Color(0xFF0E0E0E);

  static const Color primary = Color(0xFF7B61FF);
  static const Color primaryContainer = Color(0xFF917EFF);
  static const Color secondary = Color(0xFFC9BFFF);

  static const Color onSurface = Color(0xFFE5E2E1);
  static const Color onSurfaceVariant = Color(0xFFC9C4D8);

  static const Color outline = Color(0xFF928EA1);
  static const Color outlineVariant = Color(0xFF484555);

  static const Color tertiaryContainer = Color(0xFFD57A1E);
  static const Color tertiary = Color(0xFFFFB77D);
  static const Color onPrimary = Color(0xFF2E009C);
  static const Color error = Color(0xFFFFB4AB);
  static const Color errorContainer = Color(0xFF93000A);
  static const Color onPrimaryContainer = Color(0xFF28008A);

  // Keep existing names to prevent build errors immediately, but map to new colors
  static Color scaffoldBackgroundColor = background;
  static Color containerColor = surfaceContainer;
  static Color cursorColor = primary;
  static Color whiteColor = onSurface;
}
