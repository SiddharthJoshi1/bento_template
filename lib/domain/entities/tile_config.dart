import 'dart:core';

/// Tile size vocabulary for the bento grid.
///
/// Names encode both dimensions: prefix = width tier, suffix = shape.
///
/// Width tiers:
///   quarter = 0.25 of grid width
///   half    = 0.50 of grid width
///   full    = 1.00 of grid width
///
/// Shape suffixes:
///   Bar   = 0.5 units tall  (short, horizontal emphasis)
///   Card  = 1.0 units tall  (standard card height)
///   Tower = 2.0 units tall  (tall, vertical emphasis)
///
/// | TileSize     | widthFraction | heightSpan | Old name       |
/// |--------------|---------------|------------|----------------|
/// | quarterBar   | 0.25          | 0.5        | —  (new)       |
/// | quarterCard  | 0.25          | 1.0        | small          |
/// | quarterTower | 0.25          | 2.0        | slim           |
/// | halfBar      | 0.5           | 0.5        | thin           |
/// | halfCard     | 0.5           | 1.0        | medium         |
/// | halfTower    | 0.5           | 2.0        | tall           |
/// | fullBar      | 1.0           | 0.5        | banner         |
/// | fullCard     | 1.0           | 1.0        | standard       |
/// | fullTower    | 1.0           | 2.0        | fullsize       |
enum TileSize {
  quarterBar,
  quarterCard,
  quarterTower,
  halfBar,
  halfCard,
  halfTower,
  fullBar,
  fullCard,
  fullTower,
}

enum TileType { sectionTitle, map, link, image, video, text, widgets }

class TileConfig {
  final String? title;
  final String? imagePath;
  final String? url;
  final String? colour;
  final TileSize tileSize;
  final TileType type;
  final double? latitude;
  final double? longitude;
  /// Only used by [TileType.widgets] tiles — identifies the widget in [WidgetRegistry].
  final String? widgetId;
  /// Arbitrary config map passed to [InteractiveWidget.buildWithConfig].
  final Map<String, dynamic>? widgetConfig;
  /// Only used by [TileType.video] tiles — asset path or network URL to the
  /// video file. Separate from [imagePath] and [url] so all three can coexist.
  final String? videoPath;

  TileConfig({
    required this.type,
    required this.tileSize,
    required this.title,
    this.colour,
    this.imagePath,
    this.url,
    this.latitude,
    this.longitude,
    this.widgetId,
    this.widgetConfig,
    this.videoPath,
  });


  factory TileConfig.fromJson(Map<String, dynamic> json) => TileConfig(
        type: _typeFromString(json['type'] as String),
        tileSize: _sizeFromString(json['tile_size'] as String),
        title: json['title'] as String?,
        url: json['url'] as String?,
        imagePath: json['image_path'] as String?,
        colour: json['colour'] as String?,
        latitude: (json['latitude'] as num?)?.toDouble(),
        longitude: (json['longitude'] as num?)?.toDouble(),
        widgetId: json['widget_id'] as String?,
        widgetConfig: json['widget_config'] as Map<String, dynamic>?,
        videoPath: json['video_path'] as String?,
      );

  static TileSize _sizeFromString(String s) => switch (s) {
        'quarter_bar'    => TileSize.quarterBar,
        'quarter_card'   => TileSize.quarterCard,
        'quarter_tower'  => TileSize.quarterTower,
        'half_bar'       => TileSize.halfBar,
        'half_card'      => TileSize.halfCard,
        'half_tower'     => TileSize.halfTower,
        'full_bar'       => TileSize.fullBar,
        'full_card'      => TileSize.fullCard,
        'full_tower'     => TileSize.fullTower,
        // Legacy keys — kept so old JSON doesn't silently break
        'small'          => TileSize.quarterCard,
        'thin'           => TileSize.halfBar,
        'medium'         => TileSize.halfCard,
        'standard'       => TileSize.fullCard,
        'banner'         => TileSize.fullBar,
        'slim'           => TileSize.quarterTower,
        'tall'           => TileSize.halfTower,
        'fullsize'       => TileSize.fullTower,
        'long_horizontal' => TileSize.fullBar,
        'long_vertical'   => TileSize.quarterTower,
        _                => TileSize.halfCard,
      };

  static TileType _typeFromString(String s) => switch (s) {
        'section_title' => TileType.sectionTitle,
        'link'          => TileType.link,
        'text'          => TileType.text,
        'image'         => TileType.image,
        'map'           => TileType.map,
        'video'         => TileType.video,
        'widgets'       => TileType.widgets,
        _               => TileType.text,
      };

  /// Whether this tile uses a bar-shaped size (half-height horizontal strip).
  bool get isBar =>
      tileSize == TileSize.fullBar ||
      tileSize == TileSize.halfBar ||
      tileSize == TileSize.quarterBar;

  /// Whether this tile uses a tower-shaped size (tall, vertical emphasis).
  bool get isTower =>
      tileSize == TileSize.fullTower ||
      tileSize == TileSize.halfTower ||
      tileSize == TileSize.quarterTower;

  TileConfig copyWith({
    String? title,
    String? imagePath,
    String? url,
    String? colour,
    TileSize? tileSize,
    TileType? type,
    double? latitude,
    double? longitude,
    String? widgetId,
    Map<String, dynamic>? widgetConfig,
    String? videoPath,
  }) {
    return TileConfig(
      type: type ?? this.type,
      tileSize: tileSize ?? this.tileSize,
      title: title ?? this.title,
      imagePath: imagePath ?? this.imagePath,
      url: url ?? this.url,
      colour: colour ?? this.colour,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      widgetId: widgetId ?? this.widgetId,
      widgetConfig: widgetConfig ?? this.widgetConfig,
      videoPath: videoPath ?? this.videoPath,
    );
  }
}
