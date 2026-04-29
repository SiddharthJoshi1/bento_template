import 'package:flutter/material.dart';

/// Base class for all interactive bento widgets.
///
/// Implement this to register a new widget into the widgets system.
/// Each subclass is a self-contained, interactive Flutter widget that can be
/// embedded into a bento tile via [TileType.widgets].
///
/// Example:
/// ```dart
/// class ParticleWidget extends InteractiveWidget {
///   @override String get widgetId => 'particle_v1';
///   @override String get displayName => 'Particle Physics';
///   @override String get description => 'Touch-responsive particle system.';
///   @override List<String> get tags => ['animation', 'physics'];
///
///   @override
///   Widget buildWithConfig(Map<String, dynamic> config) {
///     return ParticleCanvas(config: config);
///   }
/// }
/// ```
abstract class InteractiveWidget {
  const InteractiveWidget();

  /// Unique identifier used in [TileConfig] JSON and the registry map.
  /// Convention: `snake_case_v1`, bump version on breaking config changes.
  String get widgetId;

  /// Human-readable name shown in debug/dev tooling.
  String get displayName;

  /// One-line description of what the widget does or demonstrates.
  String get description;

  /// Searchable tags — e.g. ['animation', 'physics', 'data_viz'].
  List<String> get tags;

  /// Builds the widget using optional config values from [TileConfig.widgetConfig]
  /// and the tile's background [colour] string (e.g. "#1A1A1A") if set.
  /// Implementations should derive text colour from [colour] using
  /// [ColourBrightness.contrastingTextColour] rather than hardcoding.
  /// Use defensive fallbacks — config arrives from JSON and keys may be absent.
  Widget buildWithConfig(Map<String, dynamic> config, {String? colour});
}
