import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const primary = Color(0xFF004E9F);
  static const onPrimary = Color(0xFFFFFFFF);
  static const primaryContainer = Color(0xFF0066CC);
  static const onPrimaryContainer = Color(0xFFDFE8FF);
  
  static const secondary = Color(0xFF745C00);
  static const onSecondary = Color(0xFFFFFFFF);
  static const secondaryContainer = Color(0xFFFCD03D);
  static const onSecondaryContainer = Color(0xFF705900);
  
  static const tertiary = Color(0xFF005679);
  static const onTertiary = Color(0xFFFFFFFF);
  static const tertiaryContainer = Color(0xFF00709B);
  static const onTertiaryContainer = Color(0xFFD3ECFF);

  // Surface & Background
  static const background = Color(0xFFF9F9FF);
  static const onBackground = Color(0xFF191C22);
  
  static const surface = Color(0xFFF9F9FF);
  static const onSurface = Color(0xFF191C22);
  static const surfaceVariant = Color(0xFFE1E2EB);
  static const onSurfaceVariant = Color(0xFF414753);
  
  static const surfaceContainerLowest = Color(0xFFFFFFFF);
  static const surfaceContainerLow = Color(0xFFF2F3FC);
  static const surfaceContainer = Color(0xFFECEDF6);
  static const surfaceContainerHigh = Color(0xFFE6E8F1);
  static const surfaceContainerHighest = Color(0xFFE1E2EB);

  // Outline
  static const outline = Color(0xFF727784);
  static const outlineVariant = Color(0xFFC1C6D5);

  // Error
  static const error = Color(0xFFBA1A1A);
  static const onError = Color(0xFFFFFFFF);
  static const errorContainer = Color(0xFFFFDAD6);
  static const onErrorContainer = Color(0xFF93000A);

  // Legacy/Semantic Mapping (to maintain compatibility)
  static const primaryStrong = Color(0xFF001B3E); // on-primary-fixed
  static const primarySoft = Color(0xFF00458E);   // on-primary-fixed-variant
  static const headline = Color(0xFF191C22);      // on-surface
  static const body = Color(0xFF414753);          // on-surface-variant
  static const bodyStrong = Color(0xFF191C22);    // on-surface
  static const card = Color(0xFFFFFFFF);          // surface-container-lowest
  static const border = Color(0xFFC1C6D5);        // outline-variant
  static const inputFill = Color(0xFFECEDF6);      // surface-container
  static const inputBorder = Color(0xFF727784);    // outline
  static const inputIcon = Color(0xFF414753);      // on-surface-variant
  static const divider = Color(0xFFE1E2EB);        // surface-container-highest
  static const footerText = Color(0xFF414753);     // on-surface-variant
  static const muted = Color(0xFF727784);          // outline
}
