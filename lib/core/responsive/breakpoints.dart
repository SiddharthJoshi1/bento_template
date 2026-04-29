/// Centralised responsive utilities for the Bento app.
///
/// All breakpoint logic and responsive text scaling lives here.
/// Import this file instead of using [ScreenSizeUtils] from app_styles.dart.
library;

import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// Breakpoints
// ---------------------------------------------------------------------------

/// Screen width breakpoints and helper methods.
///
/// Use these to make layout decisions based on the current screen size.
/// All values are based on a standard 4px grid.
///
/// Example:
/// ```dart
/// if (Breakpoints.isDesktop(context)) {
///   return DesktopLayout();
/// }
/// ```
class Breakpoints {


  /// Minimum width to be considered a desktop screen.
  static const double desktop = 1200.0;

  /// Minimum width to be considered a tablet screen.
  static const double tablet = 800.0;

  /// Maximum width before a screen is considered "narrow" (small mobile).
  static const double narrow = 425.0;

  /// Returns true if the screen width is >= [desktop].
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= desktop;
  }

  /// Returns true if the screen width is between [narrow] and [desktop].
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width > narrow && width < desktop;
  }

  /// Returns true if the screen width is < [narrow].
  static bool isNarrow(BuildContext context) {
    return MediaQuery.of(context).size.width < narrow;
  }

  /// Returns true if the screen width is < [desktop] (i.e. mobile or tablet).
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < desktop;
  }
}

// ---------------------------------------------------------------------------
// Responsive Typography
// ---------------------------------------------------------------------------

/// Responsive text styles scaled to the current screen width.
///
/// Wraps [Theme.of(context).textTheme] and applies a size multiplier based
/// on [Breakpoints]. Always returns styles from the active theme so colours
/// and font families stay consistent.
class ResponsiveText {
  // Base font sizes (mobile-first)
  static const double _titleLarge = 22.0;
  static const double _titleMedium = 18.0;
  static const double _titleSmall = 16.0;
  static const double _labelLarge = 14.0;
  static const double _labelMedium = 13.0;
  static const double _labelSmall = 12.0;
  static const double _caption = 12.0;

  static TextStyle? titleLarge(BuildContext context) =>
      Theme.of(context).textTheme.titleLarge?.copyWith(
        fontSize: _scale(context, _titleLarge),
      );

  static TextStyle? titleMedium(BuildContext context) =>
      Theme.of(context).textTheme.titleMedium?.copyWith(
        fontSize: _scale(context, _titleMedium),
      );

  static TextStyle? titleSmall(BuildContext context) =>
      Theme.of(context).textTheme.titleSmall?.copyWith(
        fontSize: _scale(context, _titleSmall),
      );

  static TextStyle? labelLarge(BuildContext context) =>
      Theme.of(context).textTheme.labelLarge?.copyWith(
        fontSize: _scale(context, _labelLarge),
      );

  static TextStyle? labelMedium(BuildContext context) =>
      Theme.of(context).textTheme.labelMedium?.copyWith(
        fontSize: _scale(context, _labelMedium),
      );

  static TextStyle? labelSmall(BuildContext context) =>
      Theme.of(context).textTheme.labelSmall?.copyWith(
        fontSize: _scale(context, _labelSmall),
      );

  static TextStyle? caption(BuildContext context) =>
      Theme.of(context).textTheme.bodySmall?.copyWith(
        fontSize: _scale(context, _caption),
        color: Colors.grey.shade600,
      );

  /// Scales [baseSize] by 1.2x on desktop, 1.1x on tablet, 1.0x on mobile.
  static double _scale(BuildContext context, double baseSize) {
    if (Breakpoints.isDesktop(context)) return baseSize * 1.2;
    if (Breakpoints.isTablet(context)) return baseSize * 1.1;
    return baseSize;
  }
}

// ---------------------------------------------------------------------------
// ResponsiveBuilder
// ---------------------------------------------------------------------------

/// A convenience widget that rebuilds with the correct layout for each
/// screen size. Provide at least [mobile]; [tablet] and [desktop] are
/// optional and fall back to [mobile] when omitted.
///
/// Example:
/// ```dart
/// ResponsiveBuilder(
///   mobile: MobileLayout(),
///   tablet: TabletLayout(),
///   desktop: DesktopLayout(),
/// )
/// ```
class ResponsiveBuilder extends StatelessWidget {
  /// Layout shown on screens narrower than [Breakpoints.desktop].
  final Widget mobile;

  /// Layout shown on tablet-sized screens. Falls back to [mobile] if null.
  final Widget? tablet;

  /// Layout shown on desktop-sized screens. Falls back to [mobile] if null.
  final Widget? desktop;

  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    if (Breakpoints.isDesktop(context)) return desktop ?? mobile;
    if (Breakpoints.isTablet(context)) return tablet ?? mobile;
    return mobile;
  }
}
