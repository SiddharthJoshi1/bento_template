/// Centralised theme configuration for the Bento app.
///
/// All design tokens live here — colours, spacing, icon sizes, radii, and the
/// full [ThemeData] instance. Import this file instead of reaching into
/// individual utility classes.
///
/// Usage:
/// ```dart
/// // In main.dart
/// theme: AppTheme.light,
///
/// // In widgets
/// color: AppColors.accent,
/// padding: EdgeInsets.all(AppInsets.m),
/// ```
library;

import 'package:bento_template/core/constants.dart';
import 'package:bento_template/core/theme/theme_flavour.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// ---------------------------------------------------------------------------
// Colours
// ---------------------------------------------------------------------------

/// Semantic colour definitions for the Bento app.
class AppColors {
  // -- Surfaces --
  static const Color background = Colors.white;
  static const Color cardSurface = Colors.white;
  static const Color tileSurfaceTransparent = Colors.transparent;

  // -- Text --
  static const Color textPrimary = Colors.black;
  static const Color textOnDark = Colors.white;
  static final Color textSubdued = Colors.grey.shade600;

  // -- Borders --
  static const Color tileBorder = Colors.black12;

  // -- Tile overlays --
  static final Color imageGradientStart = Colors.transparent;
  static final Color imageGradientEnd = Colors.black.withValues(alpha: 0.8);

  // -- Map tile placeholder --
  static final Color mapBackground = Colors.blue[100]!;
  static const Color mapPin = Colors.red;
  static const Color mapLabelBackground = Colors.white;
}

// ---------------------------------------------------------------------------
// Spacing
// ---------------------------------------------------------------------------

/// Padding and spacing values based on a 4px grid.
class AppInsets {
  static const double xs = 4.0;
  static const double s = 8.0;
  static const double m = 16.0;
  static const double l = 20.0;
  static const double xl = 24.0;
  static const double xxl = 48.0;
}

// ---------------------------------------------------------------------------
// Icon sizes
// ---------------------------------------------------------------------------

class AppIconSizes {
  static const double s = 16.0;
  static const double m = 24.0;
  static const double l = 32.0;
  static const double xl = 40.0;
}

// ---------------------------------------------------------------------------
// Border radii
// ---------------------------------------------------------------------------

class AppRadii {
  static final BorderRadius card = BorderRadius.circular(RadiusConstants.card);
  static final BorderRadius chip = BorderRadius.circular(RadiusConstants.chip);
}

// ---------------------------------------------------------------------------
// Theme
// ---------------------------------------------------------------------------

/// The single source of truth for [ThemeData] in the Bento app.
class AppTheme {
  AppTheme._();

  static ThemeData _build(ThemeVariant variant, Brightness brightness) {
    final base = brightness == Brightness.light
        ? GoogleFonts.interTextTheme()
        : GoogleFonts.interTextTheme(
            ThemeData(brightness: Brightness.dark).textTheme,
          );

    return ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: variant.background,
        systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: variant.background,
          statusBarColor: variant.background,
          statusBarIconBrightness:
              brightness == Brightness.light ? Brightness.dark : Brightness.light,
        ),
        elevation: 0,
      ),
      scaffoldBackgroundColor: variant.background,
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: variant.accent,
        brightness: brightness,
        surface: variant.background,
      ),
      textTheme: base.apply(
        bodyColor: variant.textColour,
        displayColor: variant.textColour,
      ),
      cardTheme: CardThemeData(
        shape: RoundedRectangleBorder(borderRadius: AppRadii.card),
      ),
    );
  }

  static ThemeData light(ThemeVariant variant) =>
      _build(variant, Brightness.light);

  static ThemeData dark(ThemeVariant variant) =>
      _build(variant, Brightness.dark);
}
