/// Semantic padding and spacing constants for Bento tiles.
/// Use these instead of hardcoded values throughout tile renderers.
library;

import 'package:flutter/material.dart';

/// Padding values used within tile content areas.
class TilePadding {

  /// Standard padding for tile headers and content (20px).
  static const EdgeInsets standard = EdgeInsets.all(20.0);

  /// Compact padding for smaller tiles (16px).
  static const EdgeInsets compact = EdgeInsets.all(16.0);

  static const EdgeInsets tiny = EdgeInsets.all(8.0);

  /// Horizontal-only padding for thin/bar tiles (24px sides).
  static const EdgeInsets horizontal = EdgeInsets.symmetric(horizontal: 24.0);

  /// Horizontal-only padding for thin/bar tiles (20px sides).
  static const EdgeInsets horizontalCompact = EdgeInsets.symmetric(horizontal: 20.0);

  /// Padding for image cards inside tiles.
  static const EdgeInsets imageCard = EdgeInsets.fromLTRB(20.0, 0, 20.0, 20.0);

  /// Small vertical + horizontal padding for image card rows.
  static const EdgeInsets imageCardRow = EdgeInsets.only(
    right: 16.0,
    top: 8.0,
    bottom: 8.0,
  );

  /// Padding for map overlay labels.
  static const EdgeInsets mapLabel = EdgeInsets.symmetric(
    horizontal: 8.0,
    vertical: 4.0,
  );
}

/// Spacing values (SizedBox gaps) used between tile elements.
class TileSpacing {

  /// Small gap between icon and title (8px).
  static const SizedBox small = SizedBox(height: 8.0);

  /// Tiny gap between title and subtitle (2px).
  static const SizedBox tiny = SizedBox(height: 2.0);

  /// Small horizontal gap between side-by-side icon and text.
  static const SizedBox horizontalSmall = SizedBox(width: 8.0);
}

/// Image sizing ratios used in tile image cards.
class TileImageSizing {

  /// Square image aspect ratio (1:1).
  static const double squareAspectRatio = 1.0;
}
