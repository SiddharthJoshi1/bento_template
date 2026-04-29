/// Contract for all analytics tracking in the app.
///
/// Implementations are swappable — Lukehog today, Sentry or PostHog tomorrow —
/// without touching any call sites. Register the concrete impl via [setupLocator].
abstract class AnalyticsRepository {
  /// Fired once on cold start.
  void trackPortfolioOpened();

  /// Fired when a link tile is tapped.
  /// [tileTitle] is the raw display title from [TileConfig] — slugification
  /// is handled by [TrackTileTapped], not here.
  void trackTileTapped(String eventName);

  /// Fired when an unhandled Flutter or platform error occurs.
  /// [context] is a short string identifying the error source
  /// e.g. `'flutter_error'` or `'platform_error'`.
  void trackError(String context);
}
