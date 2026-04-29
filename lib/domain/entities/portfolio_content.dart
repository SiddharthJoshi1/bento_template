import 'profile_data.dart';
import 'tile_config.dart';

/// The resolved portfolio content returned by [RemoteConfigRepository].
class PortfolioContent {
  const PortfolioContent({
    required this.tiles,
    required this.profile,
  });

  final List<TileConfig> tiles;
  final ProfileData profile;
}
