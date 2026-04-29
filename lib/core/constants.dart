/// App-wide constants for magic numbers.
///
/// Use these instead of hardcoded values throughout the codebase.
/// Grouped by concern so it's easy to find and adjust values.
library;

/// Layout and grid constants.
class LayoutConstants {
  /// The height of one row unit in pixels.
  /// Decoupled from width so tile heights stay consistent across all
  /// screen sizes regardless of how wide the grid is.
  static const double unitHeight = 180.0;
}

/// Border radius constants.
class RadiusConstants {
  /// Large card border radius (used on Bento tiles).
  static const double card = 24.0;

  /// Small chip/icon card border radius.
  static const double chip = 12.0;
}

/// Animation duration constants.
class AnimationConstants {
  /// Duration for the tile hover/press scale animation (milliseconds).
  static const int tileScaleDuration = 200;
}

/// Map tile constants.
class MapConstants {
  /// Raster tile URL template for the map tile renderer.
  /// Swap this to change the map style — no other code changes needed.
  ///
  /// Current: OSM Standard (free, open, attribution required).
  /// Alternative: Maptiler — 'https://api.maptiler.com/maps/streets/{z}/{x}/{y}.png?key=YOUR_KEY'
  static const String tileUrlTemplate =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

  /// User-agent package name sent with tile requests.
  /// OSM policy requires a clear, unique identifier — do not change to a generic value.
  /// Injected at build time via `--dart-define=MAP_USER_AGENT=your.package.name`.
  /// Falls back to a generic identifier if not set.
  static const String userAgentPackageName = String.fromEnvironment(
    'MAP_USER_AGENT',
    defaultValue: 'dev.bento_template.portfolio',
  );

  /// Default zoom level for map tiles.
  static const double defaultZoom = 14.0;
}

/// Remote content constants.
class RemoteConstants {
  /// Raw GitHub base URL serving content.json from the `content` branch.
  ///
  /// Injected at build time via `--dart-define=CONTENT_BASE_URL=...`.
  /// Format: `https://raw.githubusercontent.com/<user>/<repo>/content/`
  /// (trailing slash required).
  ///
  /// Falls back to an empty string — the app will use the bundled asset
  /// fallback in that case, so nothing breaks in debug without the flag.
  static const String baseContentUrl = String.fromEnvironment(
    'CONTENT_BASE_URL',
    defaultValue: '',
  );

  static const String contentJsonUrlPath =
      '${baseContentUrl}assets/data/content.json';

  /// SharedPreferences key for the cached content JSON string.
  static const String contentCacheKey = 'cached_content_json';

  /// SharedPreferences key for the cached content version string.
  static const String contentVersionKey = 'cached_content_version';

  /// Timeout for remote fetch requests.
  static const Duration fetchTimeout = Duration(seconds: 8);
}

/// Analytics constants.
class AnalyticsConstants {
  /// Lukehog app ID.
  static const String lukehogAppId = String.fromEnvironment(
    'LUKEHOG_APP_ID',
  );
}
