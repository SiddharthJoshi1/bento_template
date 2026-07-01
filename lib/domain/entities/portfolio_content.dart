import 'profile_data.dart';
import 'tile_config.dart';

/// The resolved portfolio content returned by [RemoteConfigRepository].
class PortfolioContent {
  const PortfolioContent({
    required this.tiles,
    required this.profile,
    this.themeFlavourId,
    this.themeMode,
  });

  final List<TileConfig> tiles;
  final ProfileData profile;

  /// Optional initial theme flavour from content.json (e.g. "dusk", "forest").
  final String? themeFlavourId;

  /// Optional initial theme mode from content.json ("light" or "dark").
  final String? themeMode;
}
